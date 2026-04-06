# YACL Website

Jekyll site for the Yale Applied Cryptography Laboratory.

## Local Setup

Requirements:
- Ruby `3.4.1` (see `.ruby-version`)
- Bundler

Install dependencies:

```bash
bundle install
```

Run the site locally with live reload:

```bash
bundle exec jekyll serve --livereload
```

Open:
- `http://127.0.0.1:4000/`

Rebuild the static site without serving:

```bash
bundle exec jekyll build
```

Clean and rebuild from scratch:

```bash
bundle exec jekyll clean
bundle exec jekyll build
```

The generated site goes to `_site/`.

## Content Editing Guide

Most routine content lives in `_data/`:
- [_data/seminars.yml](_data/seminars.yml)
- [_data/updates.yml](_data/updates.yml)
- [_data/people.yml](_data/people.yml)

### Add A Seminar

Seminars live in `upcoming:` and `past:` lists inside [_data/seminars.yml](_data/seminars.yml).

Common fields:
- `date`: `YYYY-MM-DD`
- `time`: usually only for upcoming talks, for example `11am ET`
- `speaker`
- `affiliation`
- `title`
- `livestream_url`: typically for upcoming talks
- `video_url`: typically for past talks
- `links`: optional list of paper or resource URLs
- `abstract`
- `bio`

Example upcoming entry:

```yml
upcoming:
  - date: "2026-05-22"
    time: "11am ET"
    speaker: "Ada Lovelace"
    affiliation: "Example University"
    title: "Provable Widgets"
    livestream_url: "https://yale.zoom.us/j/..."
    links:
      - "https://eprint.iacr.org/2026/123"
    abstract: >-
      Short abstract here.
    bio: >-
      Short bio here.
```

Example past entry:

```yml
past:
  - date: "2026-05-22"
    speaker: "Ada Lovelace"
    affiliation: "Example University"
    title: "Provable Widgets"
    video_url: "https://youtu.be/..."
    links:
      - "https://eprint.iacr.org/2026/123"
    abstract: >-
      Short abstract here.
    bio: >-
      Short bio here.
```

Notes:
- Keep upcoming talks in chronological order.
- Keep past talks in reverse chronological order, newest first.
- `links` is optional; omit it entirely if there are no links.
- `abstract` and `bio` should use `>-` to avoid quote escaping.
- When a seminar happens, move it from `upcoming` to `past` and swap `livestream_url` for `video_url` if a recording exists.

### Add An Update

Updates live in [_data/updates.yml](_data/updates.yml).

Fields:
- `date`: `YYYY-MM-DD`
- `tag`: one of the existing tags such as `paper`, `award`, `talk`, or `news`
- `text`: the update body; Markdown is supported
- `url`: optional site-relative or external link

Example single-line update:

```yml
- date: "2026-05-01"
  tag: news
  text: "We launched a new seminar page."
```

Example multi-line update with bullets:

```yml
- date: "2026-05-01"
  tag: paper
  text: |
    New accepted papers:

    - [Paper One](https://example.com/paper-1)
    - [Paper Two](https://example.com/paper-2)
```

Notes:
- Keep updates in reverse chronological order, newest first.
- Use `|` for multi-paragraph or bulleted Markdown content.
- If the whole update should link to a YACL page, add `url:`.

### Add Or Change A People Entry

People entries live in [_data/people.yml](_data/people.yml).

Current sections are:
- `faculty`
- `visitors`
- `postdocs`
- `phd_students`
- `alumni_visitors`
- `alumni_postdocs`
- `alumni_phd_students`

Common fields:
- `name`
- `role`: mostly used for faculty and visitors
- `affiliation`: mostly used for alumni sections
- `url`
- `email`
- `research`
- `photo`

Example current member:

```yml
postdocs:
  - name: "Ada Lovelace"
    url: https://example.edu/~ada
    research: verifiable computing, cryptography
    photo: /assets/images/people/ada-lovelace.jpg
```

Example alumni entry:

```yml
alumni_phd_students:
  - name: "Ada Lovelace"
    affiliation: "Yale → Example University"
    url: https://example.edu/~ada
    photo: /assets/images/people/ada-lovelace.jpg
```

Photo workflow:
- Put images in `assets/images/people/`.
- Reference them with a site path like `/assets/images/people/name.jpg`.
- If `photo` is omitted, the people page falls back to the placeholder image defined at the top of `people.yml`.

Notes:
- Keep names ordered however the section currently expects; preserve the existing style within each list.
- To move someone between categories, remove the old entry and add the new one under the target section.
- `role`, `research`, `url`, `email`, and `photo` are optional unless you want them displayed.

## Issue Templates

GitHub issue templates are available for:
- seminar additions/changes
- updates
- people entries

Use them when you want to request a content change without editing YAML directly.

## Deployment

Deployment details live in [DEPLOYMENT.md](DEPLOYMENT.md).

The production deploy is triggered by pushes to `main` via `.github/workflows/deploy.yml` and runs `./deploy-cs.sh` on a self-hosted runner.
