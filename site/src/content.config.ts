import { defineCollection } from 'astro:content';
import { glob } from 'astro/loaders';

/**
 * Every collection reads the repository's own files. The wiki has no second
 * copy of any rule — that is the repository's sixth hard rule, applied to its
 * own documentation site.
 */
const method = defineCollection({
  loader: glob({ pattern: '[0-9][0-9]-*.md', base: '../method' }),
});

const methodIndex = defineCollection({
  loader: glob({ pattern: 'README.md', base: '../method' }),
});

const checklists = defineCollection({
  loader: glob({ pattern: '*.md', base: '../checklists' }),
});

const prompts = defineCollection({
  loader: glob({ pattern: '[0-9][0-9]-*.md', base: '../kit/prompts' }),
});

const kitSkills = defineCollection({
  loader: glob({ pattern: '*/SKILL.md', base: '../kit/skills' }),
});

const kitTemplates = defineCollection({
  loader: glob({ pattern: '*.md', base: '../kit' }),
});

const kitAdr = defineCollection({
  loader: glob({ pattern: '*.md', base: '../kit/adrs' }),
});

const adrs = defineCollection({
  loader: glob({ pattern: '*.md', base: '../examples/catalog-compare-api/adrs' }),
});

const packet = defineCollection({
  loader: glob({ pattern: '*.md', base: '../examples/catalog-compare-api' }),
});

const packetSkills = defineCollection({
  loader: glob({ pattern: '*/SKILL.md', base: '../examples/catalog-compare-api/skills' }),
});

const root = defineCollection({
  loader: glob({ pattern: '{BIBLIOGRAPHY,CONTRIBUTING,AGENTS,HANDOFF}.md', base: '..' }),
});

export const collections = {
  method,
  methodIndex,
  checklists,
  prompts,
  kitSkills,
  kitTemplates,
  kitAdr,
  adrs,
  packet,
  packetSkills,
  root,
};
