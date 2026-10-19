// Run: node --test plugins/corp/hooks/guard.test.mjs
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import { decide } from './guard.mjs';

const cwd = process.platform === 'win32' ? 'C:\\proj' : '/proj';
const call = (agent_type, tool_name, tool_input) => decide({ agent_type, tool_name, tool_input, cwd });

test('manager and non-corp agents are never restricted', () => {
  assert.equal(call(undefined, 'Agent', { subagent_type: 'corp:security-lead' }), null);
  assert.equal(call('general-purpose', 'Bash', { command: 'git push' }), null);
});

test('rule 1: leads dispatch only their roster', () => {
  assert.equal(call('corp:dev-lead', 'Agent', { subagent_type: 'corp:builder' }), null);
  assert.equal(call('dev-lead', 'Agent', { subagent_type: 'corp:scout' }), null);
  assert.match(call('dev-lead', 'Agent', { subagent_type: 'corp:security-lead' }), /may dispatch only/);
  assert.match(call('planning-lead', 'Agent', { subagent_type: 'corp:builder' }), /may dispatch only/);
  assert.match(call('qa-lead', 'Task', { subagent_type: 'general-purpose' }), /may dispatch only/);
  assert.match(call('dev-lead', 'Agent', { subagent_type: 'builder' }), /may dispatch only/); // must be namespaced
  assert.match(call('scout', 'Agent', { subagent_type: 'corp:scout' }), /worker/);
});

test('rule 1b: leads dispatch workers in the foreground only', () => {
  assert.match(call('qa-lead', 'Agent', { subagent_type: 'corp:scout', run_in_background: true }), /run_in_background: false/);
  assert.equal(call('qa-lead', 'Agent', { subagent_type: 'corp:scout', run_in_background: false }), null);
  assert.equal(call(undefined, 'Agent', { subagent_type: 'corp:qa-lead', run_in_background: true }), null); // manager may background leads
});

test('rule 2: scouts never write in the project; review roles write only under docs/ or .corp/', () => {
  assert.match(call('corp:scout', 'Write', { file_path: 'docs/x.md' }), /never in the project/);
  assert.match(call('web-scout', 'Edit', { file_path: 'a.js' }), /read-only/);
  assert.equal(call('qa-lead', 'Write', { file_path: 'docs/qa/report.md' }), null);
  assert.equal(call('security-lead', 'Write', { file_path: `${cwd}/.corp/sec.md` }), null);
  assert.match(call('security-lead', 'Edit', { file_path: 'src/auth.js' }), /may write only/);
  assert.match(call('qa-lead', 'Write', { file_path: 'docs/../src/a.js' }), /may write only/);
  assert.match(call('qa-lead', 'Write', { file_path: '../other/docs/a.md' }), /may write only/);
  assert.match(call('qa-lead', 'Write', { file_path: 'documents/a.md' }), /may write only/);
  assert.equal(call('builder', 'Edit', { file_path: 'src/a.js' }), null);
  assert.equal(call('dev-lead', 'Write', { file_path: 'src/a.js' }), null);
});

test('rule 3: workers take no outward actions', () => {
  for (const cmd of ['git push origin main', 'npm test && git commit -am x', 'npm i lodash',
    'pip install requests', 'gh pr create --fill', 'vercel --prod deploy', 'docker push img']) {
    assert.match(call('builder', 'Bash', { command: cmd }), /outward/, cmd);
  }
  for (const cmd of ['git log --oneline', 'npm test', 'git status', 'ls deploy/', 'npm ci']) {
    assert.equal(call('scout', 'Bash', { command: cmd }), null, cmd);
  }
  assert.equal(call('dev-lead', 'Bash', { command: 'git commit -m x' }), null); // leads commit when briefed
});

test('CLI: deny exits 2 with reason, allow and malformed input exit 0', () => {
  const script = fileURLToPath(new URL('./guard.mjs', import.meta.url));
  const run = (stdin) => spawnSync(process.execPath, [script], { input: stdin, encoding: 'utf8' });
  const denied = run(JSON.stringify({ agent_type: 'scout', tool_name: 'Bash', tool_input: { command: 'git push' } }));
  assert.equal(denied.status, 2);
  assert.match(denied.stderr, /corp guard:/);
  assert.equal(run(JSON.stringify({ tool_name: 'Bash', tool_input: { command: 'git push' } })).status, 0);
  assert.equal(run('not json').status, 0);
});

test('rule 2: review roles may write throwaway scripts in the OS temp dir, never product code', async () => {
  const { tmpdir } = await import('node:os');
  const { join } = await import('node:path');
  const scratch = join(tmpdir(), 'claude', 'session', 'scratchpad', 'mutate.mjs');
  assert.equal(call('qa-lead', 'Write', { file_path: scratch }), null);
  assert.equal(call('security-lead', 'Write', { file_path: scratch }), null);
  const outside = process.platform === 'win32' ? 'C:\\Windows\\evil.txt' : '/etc/evil';
  assert.match(call('qa-lead', 'Write', { file_path: outside }), /may write only/);
  // A project that itself lives in temp: its source is still off limits, its docs/ is fine.
  const proj = join(tmpdir(), 'proj');
  const inTmp = (file_path) => decide({ agent_type: 'qa-lead', tool_name: 'Write', tool_input: { file_path }, cwd: proj });
  assert.match(inTmp('src/a.js'), /may write only/);
  assert.match(inTmp(join(proj, 'src', 'a.js')), /may write only/);
  assert.equal(inTmp('docs/qa.md'), null);
  assert.equal(call('scout', 'Write', { file_path: scratch }), null); // scouts: scratch only
  assert.match(decide({ agent_type: 'scout', tool_name: 'Write', tool_input: { file_path: 'src/a.js' }, cwd: proj }), /never in the project/);
});
