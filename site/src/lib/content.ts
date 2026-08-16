import { getCollection, type CollectionEntry } from 'astro:content';

export const REPO = 'https://github.com/cfpperche/context-before-code';
export const BLOB = `${REPO}/blob/main/`;

/** The first `# ` line of a markdown file is its title. */
export function headingOf(body: string | undefined, fallback = 'Untitled'): string {
  const match = body?.match(/^#\s+(.+)$/m);
  return match ? match[1].trim() : fallback;
}

/** `# 3. Research` → `{ number: '3', title: 'Research' }` */
export function numberedHeading(body: string | undefined) {
  const heading = headingOf(body);
  const match = heading.match(/^(\d+)\.\s+(.*)$/);
  return match
    ? { number: match[1], title: match[2] }
    : { number: null as string | null, title: heading };
}

/** First paragraph after the title, used as a page description. */
export function summaryOf(body: string | undefined, fallback: string): string {
  if (!body) return fallback;
  const withoutFrontmatter = body.replace(/^---[\s\S]*?---\n/, '');
  const lines = withoutFrontmatter.split('\n');
  const buffer: string[] = [];
  let seenHeading = false;
  for (const line of lines) {
    if (/^#{1,3}\s/.test(line)) {
      if (buffer.length) break;
      seenHeading = true;
      continue;
    }
    if (!seenHeading) continue;
    if (!line.trim()) {
      if (buffer.length) break;
      continue;
    }
    if (/^[|>\-*`]/.test(line.trim())) break;
    buffer.push(line.trim());
  }
  const text = buffer.join(' ').replace(/[*`_[\]]/g, '').replace(/\(.*?\)/g, '').trim();
  return text.length > 20 ? text : fallback;
}

/** Pull the prose under a named `## ` section, flattened to one paragraph. */
export function sectionOf(body: string | undefined, heading: string): string {
  if (!body) return '';
  const pattern = new RegExp(`^##\\s+${heading}\\s*$([\\s\\S]*?)(?=^##\\s|\\Z)`, 'im');
  const match = body.match(pattern);
  if (!match) return '';
  return match[1]
    .split('\n')
    .map((line) => line.replace(/^[-*]\s+/, '').trim())
    .filter(Boolean)
    .join(' ')
    .replace(/`([^`]+)`/g, '$1')
    .replace(/\*\*([^*]+)\*\*/g, '$1')
    .trim();
}

export type Step = {
  id: string;
  number: string;
  title: string;
  href: string;
  source: string;
  summary: string;
  goal: string;
  stop: string;
};

export async function methodSteps(base: string): Promise<Step[]> {
  const entries = (await getCollection('method')) as CollectionEntry<'method'>[];
  return entries
    .sort((a, b) => a.id.localeCompare(b.id))
    .map((entry) => {
      const { number, title } = numberedHeading(entry.body);
      return {
        id: entry.id,
        number: number ?? entry.id.slice(0, 2),
        title,
        href: `${base}routine/${entry.id}/`,
        source: `method/${entry.id}.md`,
        summary: summaryOf(entry.body, ''),
        goal: sectionOf(entry.body, 'Goal'),
        stop: sectionOf(entry.body, 'Stop condition'),
      };
    });
}

/** Skills carry real frontmatter: name + description. */
export function skillMeta(entry: { id: string; data: Record<string, unknown>; body?: string }) {
  const name = typeof entry.data.name === 'string' ? entry.data.name : entry.id.split('/')[0];
  const description =
    typeof entry.data.description === 'string'
      ? entry.data.description.replace(/\s+/g, ' ').trim()
      : '';
  return { name, description, title: headingOf(entry.body, name) };
}
