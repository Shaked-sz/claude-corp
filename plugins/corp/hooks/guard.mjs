#!/usr/bin/env node
// corp guard: PreToolUse hook that enforces the org's tool rules per agent.
// Only corp agents are restricted; the manager (main thread) and everything else pass.
// Exit 2 + stderr = deny (stderr becomes the reason Claude sees). Exit 0 = allow.
import { appendFileSync, readFileSync } from 'node:fs';
import { resolve, relative, isAbsolute } from 'node:path';
import { tmpdir } from 'node:os';
import { fileURLToPath } from 'node:url';

const ROSTER = {
  'architecture-lead': ['scout', 'web-scout', 'builder'],
  'design-lead': ['scout', 'web-scout', 'builder'],
  'security-lead': ['scout', 'web-scout'],
  'dev-lead': ['scout', 'builder'],
  'planning-lead': ['scout'],
  'qa-lead': ['scout'],
  'talent-lead': ['scout', 'web-scout'],
};
const WORKERS = ['scout', 'web-scout', 'builder'];
// Review roles may write reports only under these project folders; scouts under none.
// All three may also write throwaway files (probe scripts, mutation copies) in the OS temp dir.
const WRITE_ROOTS = { 'qa-lead': ['docs', '.corp'], 'security-lead': ['docs', '.corp'], scout: [] };
const NO_WRITE = ['web-scout'];
// ponytail: regex screen, not a shell parser. Catches the common forms, including chained ones.
const OUTWARD = [
  /\bgit\s+(push|commit)\b/,
  /\b(npm|pnpm|yarn|bun)\s+(install|i|add|publish)\b/,
  /\bpip3?\s+install\b/,
  /\buv\s+(add|pip\s+install)\b/,
  /\b(cargo|gem)\s+(install|publish)\b/,
  /\b(docker\s+push|kubectl\s+apply|terraform\s+apply)\b/,
  /\bgh\s+(pr\s+(create|merge)|release\s+create)\b/,
  /\b(vercel|netlify|flyctl|fly|heroku)\b.*\bdeploy\b/,
];

const bare = (name) => String(name ?? '').replace(/^corp:/, '');
const within = (base, p) => { const r = relative(base, p); return r !== '' && !r.startsWith('..') && !isAbsolute(r); };

export function decide(input) {
  const who = bare(input?.agent_type);
  const tool = input?.tool_name;
  const args = input?.tool_input ?? {};
  const isCorp = who in ROSTER || WORKERS.includes(who);
  if (!isCorp) return null;

  if (tool === 'Agent' || tool === 'Task') {
    const target = String(args.subagent_type ?? '');
    const allowed = ROSTER[who] ?? [];
    if (target.startsWith('corp:') && allowed.includes(bare(target))) {
      return args.run_in_background === true
        ? `${who}: dispatch workers with run_in_background: false. Your report is final, so a background worker's results would reach nobody. Send independent workers as several Agent calls in one message; they still run in parallel.`
        : null;
    }
    return allowed.length
      ? `${who} may dispatch only ${allowed.map((a) => 'corp:' + a).join(', ')}, not "${target}". Teams never dispatch each other: put it under NEEDS FROM OTHER TEAMS and the manager routes it.`
      : `${who} is a worker and may not dispatch agents. Return NEEDS LEAD instead.`;
  }

  if (['Write', 'Edit', 'MultiEdit', 'NotebookEdit'].includes(tool)) {
    if (NO_WRITE.includes(who)) return `${who} is read-only. Report findings instead of editing files.`;
    const roots = WRITE_ROOTS[who];
    if (roots) {
      const cwd = input.cwd || process.cwd();
      const abs = resolve(cwd, String(args.file_path ?? args.notebook_path ?? ''));
      const rel = relative(cwd, abs);
      const inProject = rel === '' || within(cwd, abs);
      // Inside the project: reports only. Outside it: throwaway scripts in the OS temp dir (scratchpads) only.
      const ok = inProject
        ? roots.some((r) => rel.split(/[\\/]/)[0].toLowerCase() === r)
        : within(tmpdir(), abs);
      if (!ok) {
        const where = roots.length ? `under ${roots.join('/ or ')}/ in the project, or scratch files in the temp folder` : 'scratch files in the temp folder, never in the project';
        return `${who} reviews and reports; it may write only ${where}, not "${abs}". Fixes go back to Development through the manager.`;
      }
    }
    return null;
  }

  if (tool === 'Bash' && WORKERS.includes(who)) {
    const cmd = String(args.command ?? '');
    if (OUTWARD.some((re) => re.test(cmd))) {
      return `${who} may not run outward actions (commit, push, install, publish, deploy). Return NEEDS LEAD; the lead or manager does it once the user approved.`;
    }
  }
  return null;
}

if (process.argv[1] && resolve(process.argv[1]) === fileURLToPath(import.meta.url)) {
  let input;
  try {
    input = JSON.parse(readFileSync(0, 'utf8'));
  } catch {
    process.exit(0); // malformed hook input is a platform problem; don't brick the session
  }
  if (process.env.CORP_GUARD_LOG) {
    try { appendFileSync(process.env.CORP_GUARD_LOG, JSON.stringify(input) + '\n'); } catch {}
  }
  const reason = decide(input);
  if (reason) {
    process.stderr.write(`corp guard: ${reason}\n`);
    process.exit(2);
  }
}
