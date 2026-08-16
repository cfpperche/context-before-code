// @ts-check
import { defineConfig } from 'astro/config';
import mdx from '@astrojs/mdx';
import sitemap from '@astrojs/sitemap';
import { fileURLToPath } from 'node:url';
import path from 'node:path';

const REPO_ROOT = fileURLToPath(new URL('../', import.meta.url));
const BASE = '/context-before-code';
const BLOB = 'https://github.com/cfpperche/context-before-code/blob/main/';

/**
 * The wiki renders the repository's own markdown. Those files link to each
 * other with relative paths that only make sense on disk, so rewrite them to
 * wiki routes where a page exists and to GitHub otherwise.
 */
function repoPathToRoute(relative) {
  // A .tmpl file has no wiki page of its own: send the reader to the file.
  if (relative.endsWith('.tmpl')) return null;
  const clean = relative;

  if (clean === 'README.md') return `${BASE}/`;
  if (clean === 'BIBLIOGRAPHY.md') return `${BASE}/bibliography/`;
  if (clean === 'CONTRIBUTING.md') return `${BASE}/gate/#contributing`;
  if (clean === 'AGENTS.md' || clean === 'CLAUDE.md' || clean === 'GROK.md') {
    return `${BASE}/gate/#agent-files`;
  }
  if (clean === 'HANDOFF.md') return `${BASE}/gate/#handoff`;

  if (clean === 'method/README.md') return `${BASE}/routine/`;
  const method = clean.match(/^method\/(\d\d-[a-z-]+)\.md$/);
  if (method) return `${BASE}/routine/${method[1]}/`;

  const checklist = clean.match(/^checklists\/([a-z-]+)\.md$/);
  if (checklist) return `${BASE}/checklists/${checklist[1]}/`;

  const prompt = clean.match(/^kit\/prompts\/(\d\d-[a-z-]+)\.md$/);
  if (prompt) return `${BASE}/kit/#prompt-${prompt[1]}`;
  const kitSkill = clean.match(/^kit\/skills\/([a-z-]+)\/SKILL\.md$/);
  if (kitSkill) return `${BASE}/kit/#skill-${kitSkill[1]}`;
  if (clean.startsWith('kit/')) return `${BASE}/kit/`;

  const adr = clean.match(/^examples\/catalog-compare-api\/adrs\/(\d\d\d-[a-z-]+)\.md$/);
  if (adr) return `${BASE}/example/adr/${adr[1]}/`;
  if (clean.startsWith('examples/catalog-compare-api/skills/')) {
    return `${BASE}/example/skills/`;
  }
  const packet = clean.match(/^examples\/catalog-compare-api\/([A-Za-z-]+)\.md$/);
  if (packet) {
    const id = packet[1].toLowerCase();
    return id === 'readme' ? `${BASE}/example/` : `${BASE}/example/${id}/`;
  }
  if (clean.startsWith('examples/')) return `${BASE}/example/`;

  return null;
}

/** @returns {import('unified').Plugin} */
function rehypeRepoLinks() {
  return (tree, file) => {
    const source = file?.history?.[0] ?? file?.path;
    const dir = source ? path.dirname(source) : REPO_ROOT;

    const walk = (node) => {
      if (node.type === 'element' && node.tagName === 'a') {
        const href = node.properties?.href;
        if (typeof href === 'string' && !/^([a-z]+:|#|\/)/i.test(href)) {
          const [target, hash = ''] = href.split('#');
          const absolute = path.resolve(dir, target);
          const relative = path.relative(REPO_ROOT, absolute);
          if (!relative.startsWith('..')) {
            const route = repoPathToRoute(relative.split(path.sep).join('/'));
            node.properties.href = route
              ? route + (route.includes('#') || !hash ? '' : `#${hash}`)
              : BLOB + relative + (hash ? `#${hash}` : '');
            if (!route) {
              node.properties.rel = 'noreferrer';
              node.properties['data-external'] = 'true';
            }
          }
        }
      }
      for (const child of node.children ?? []) walk(child);
    };

    walk(tree);
  };
}

export default defineConfig({
  site: 'https://cfpperche.github.io',
  base: BASE,
  trailingSlash: 'always',
  integrations: [mdx(), sitemap()],
  markdown: {
    rehypePlugins: [rehypeRepoLinks],
    shikiConfig: {
      theme: 'github-light',
      wrap: false,
    },
  },
  devToolbar: { enabled: false },
});
