import { getCollection } from 'astro:content';
import { headingOf, methodSteps } from './content';

export type NavItem = { href: string; label: string; number?: string | null };
export type NavSection = { title: string; items: NavItem[] };

export async function getNav(base: string): Promise<NavSection[]> {
  const steps = await methodSteps(base);

  const checklists = (await getCollection('checklists'))
    .sort((a, b) => a.id.localeCompare(b.id))
    .map((entry) => ({
      href: `${base}checklists/${entry.id}/`,
      label: headingOf(entry.body, entry.id),
    }));

  const adrs = (await getCollection('adrs'))
    .filter((entry) => entry.id !== '000-template')
    .sort((a, b) => a.id.localeCompare(b.id))
    .map((entry) => ({
      href: `${base}example/adr/${entry.id}/`,
      label: headingOf(entry.body, entry.id).replace(/^ADR \d+:\s*/, ''),
      number: entry.id.slice(0, 3),
    }));

  return [
    {
      title: 'Start here',
      items: [
        { href: base, label: 'Overview' },
        { href: `${base}routine/`, label: 'The routine' },
      ],
    },
    {
      title: 'Steps',
      items: steps.map((step) => ({
        href: step.href,
        label: step.title,
        number: step.number,
      })),
    },
    {
      title: 'Working files',
      items: [
        { href: `${base}kit/`, label: 'The kit' },
        { href: `${base}example/`, label: 'Worked example' },
        ...adrs,
      ],
    },
    { title: 'Checklists', items: checklists },
    {
      title: 'Reference',
      items: [
        { href: `${base}reference/`, label: 'Reference index' },
        { href: `${base}bibliography/`, label: 'Bibliography' },
        { href: `${base}gate/`, label: 'Repository machinery' },
        { href: `${base}design/`, label: 'Design system' },
      ],
    },
  ];
}
