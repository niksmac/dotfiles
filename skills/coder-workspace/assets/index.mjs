#!/usr/bin/env node
// Rebuilds _coder/INDEX.md from file frontmatter and checks naming rules.
//   node _coder/index.mjs              rebuild INDEX.md, list problems
//   node _coder/index.mjs next <type>  print the next file number for a type
//   node _coder/index.mjs find <word>… list files whose name, title or description has every word
//   node _coder/index.mjs open         list open and wip files
import { existsSync, readdirSync, readFileSync, writeFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = dirname(fileURLToPath(import.meta.url));
const TYPES = {
  issue: 'issues',
  plan: 'plans',
  doc: 'docs',
  report: 'reports',
  spec: 'specs',
  benchmark: 'benchmarks',
};
const STATUSES = ['open', 'wip', 'closed', 'abandoned'];
const REQUIRED = ['title', 'status', 'createdDate', 'modifiedDate'];

function frontmatter(text) {
  const m = text.match(/^---\n([\s\S]*?)\n---\n/);
  if (!m) return null;
  const out = {};
  for (const line of m[1].split('\n')) {
    const kv = line.match(/^(\w+):\s*(.*)$/);
    if (kv) out[kv[1]] = kv[2].replace(/^["'](.*)["']$/, '$1');
  }
  return out;
}

// Types kept as one folder per entry: NNN_<type>_<slug>/report.md plus data.
const FOLDER_TYPES = new Set(['benchmark']);
const FOLDER_DOC = 'report.md';

function read(path) {
  return existsSync(path) ? frontmatter(readFileSync(path, 'utf8')) : null;
}

function list(dir) {
  if (!existsSync(join(root, dir))) return [];
  return readdirSync(join(root, dir), { withFileTypes: true }).filter((d) => !d.name.startsWith('.'));
}

const isDoc = (d) => !d.isDirectory() && d.name.endsWith('.md');

function scan(type) {
  const dir = TYPES[type];
  const names = list(dir);
  if (FOLDER_TYPES.has(type)) {
    return names
      .map((d) => d.name)
      .sort()
      .map((file) => ({ file, dir, where: `${dir}/${file}/${FOLDER_DOC}`, meta: read(join(root, dir, file, FOLDER_DOC)) }));
  }
  return names
    .filter(isDoc)
    .map((d) => d.name)
    .sort()
    .map((file) => ({ file, dir, where: `${dir}/${file}`, meta: read(join(root, dir, file)) }));
}

// Entries scan() skips in file types: anything but .md files, except a data
// folder named after its file (NNN_<type>_<slug>/ beside NNN_<type>_<slug>.md).
function strays(type) {
  if (FOLDER_TYPES.has(type)) return [];
  const names = list(TYPES[type]);
  const docs = new Set(names.filter(isDoc).map((d) => d.name));
  return names
    .filter((d) => !docs.has(d.name) && !(d.isDirectory() && docs.has(`${d.name}.md`)))
    .map((d) => d.name)
    .sort();
}

const [cmd, arg] = process.argv.slice(2);
if (cmd === 'next') {
  if (!TYPES[arg]) throw new Error(`type must be one of: ${Object.keys(TYPES).join(', ')}`);
  const max = Math.max(0, ...scan(arg).map((e) => parseInt(e.file, 10) || 0));
  console.log(String(max + 1).padStart(3, '0'));
  process.exit(0);
}
if (cmd === 'find' || cmd === 'open') {
  const words = process.argv.slice(3).map((w) => w.toLowerCase());
  if (cmd === 'find' && !words.length) {
    console.error('usage: node _coder/index.mjs find <word>…');
    process.exit(2);
  }
  for (const type of Object.keys(TYPES)) {
    for (const { file, where, meta } of scan(type)) {
      const status = meta?.status ?? '?';
      const text = `${file} ${meta?.title ?? ''} ${meta?.description ?? ''}`.toLowerCase();
      const hit = cmd === 'open' ? status === 'open' || status === 'wip' : words.every((w) => text.includes(w));
      if (hit) console.log(`${where}  ${status}  ${meta?.title ?? ''}`);
    }
  }
  process.exit(0);
}

const problems = [];
const top = readdirSync(root).filter(
  (f) => !f.startsWith('.') && !['README.md', 'INDEX.md', 'index.mjs', 'logs', ...Object.values(TYPES)].includes(f),
);
for (const f of top) problems.push(`${f}: stray entry in _coder/ root, move it into a type folder`);

const cell = (s) => String(s ?? '').replaceAll('|', '\\|');
const sections = [];
const counts = {};
for (const [type, dir] of Object.entries(TYPES)) {
  const entries = scan(type);
  const seen = new Set();
  const rows = [];
  const folder = FOLDER_TYPES.has(type);
  for (const f of strays(type)) {
    problems.push(`${dir}/${f}: stray entry, name it NNN_${type}_<slug>.md or give it the name of the file its data belongs to`);
  }
  for (const { file, where, meta } of entries) {
    const ext = folder ? '' : '\\.md';
    const name = file.match(new RegExp(`^(\\d{3})_${type}_[a-z0-9]+(?:-[a-z0-9]+)*${ext}$`));
    if (!name) {
      problems.push(`${dir}/${file}: name must be NNN_${type}_<lowercase-hyphen-slug>${folder ? '/' : '.md'}`);
    } else if (seen.has(name[1])) problems.push(`${where}: duplicate number ${name[1]}`);
    else seen.add(name[1]);
    if (!meta) {
      problems.push(`${where}: missing frontmatter`);
      continue;
    }
    for (const key of REQUIRED) if (!meta[key]) problems.push(`${where}: missing ${key}`);
    if (meta.status && !STATUSES.includes(meta.status)) {
      problems.push(`${where}: status "${meta.status}" not in ${STATUSES.join('|')}`);
    }
    counts[meta.status] = (counts[meta.status] ?? 0) + 1;
    rows.push(
      `| ${name?.[1] ?? '?'} | [${cell(meta.title)}](${where}) | ${cell(meta.status)} | ${cell(meta.createdDate)} | ${cell(meta.modifiedDate)} |`,
    );
  }
  sections.push(
    `## ${dir[0].toUpperCase()}${dir.slice(1)} (${entries.length})\n\n` +
      '| # | Title | Status | Created | Modified |\n|---|---|---|---|---|\n' +
      (rows.join('\n') || '| | none | | | |'),
  );
}

const summary = STATUSES.map((s) => `${s} ${counts[s] ?? 0}`).join(' · ');
writeFileSync(
  join(root, 'INDEX.md'),
  `# _coder index\n\nGenerated by \`node _coder/index.mjs\`; do not edit by hand. Rules: [README.md](README.md).\n\n` +
    `Status: ${summary}\n\n${sections.join('\n\n')}\n`,
);
if (problems.length) {
  console.error(problems.join('\n'));
  process.exit(1);
}
console.log('INDEX.md rebuilt, no problems');
