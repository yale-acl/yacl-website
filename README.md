# YACL Website

Jekyll site for the Yale Applied Cryptography Laboratory.

## Local Setup

Requirements:
- Ruby `4.0.6` (see `.ruby-version`)
- Bundler

### macOS

Install `rbenv` with Homebrew, initialize it as instructed, and restart your shell:

```bash
brew install rbenv ruby-build
rbenv init
```

From the repository root, install the exact pinned Ruby and Bundler versions:

```bash
rbenv install "$(sed -n '1p' .ruby-version)"
gem install bundler -v 4.0.8
```

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
- `time`: upcoming talks only, for example `"10:30 am - 11:30 am ET"`
- `location`: upcoming talks only, for example `"AKW 200"`
- `speaker`
- `photo`: optional headshot, `/assets/images/speakers/firstname-lastname.ext`
- `affiliation`
- `title`: omit it entirely (don't write `TBA`) until the speaker sends one
- `livestream_url`: upcoming talks only
- `video_url`: past talks with a recording; the card shows the YouTube thumbnail
- `thumbnail`: past talks with no recording; a 16:9 title card in
  `/assets/images/thumbnail/` shown where the video thumbnail would go. Ignored
  when `video_url` is present.
- `links`: optional list of paper or resource URLs, either bare strings or
  `{ title:, url: }` objects (preferred for new entries)
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
      - title: "Provable Widgets"
        url: "https://eprint.iacr.org/2026/123"
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
- When a seminar happens, move its block to the **top** of `past`, delete
  `time`, `location`, and `livestream_url`, and add `video_url` once the
  recording is up (strip any `?si=...` share parameter). If there is no
  recording, add `thumbnail` instead.

### Add An Update

Updates live in [_data/updates.yml](_data/updates.yml). The home page renders them as tiles in a masonry grid, newest first. The first `updates_preview_count` entries (set in `_config.yml`, currently 6) show by default and the rest sit behind a "Show all" button.

Fields:
- `date`: `YYYY-MM-DD`
- `tag`: one of the existing tags such as `paper`, `award`, `talk`, or `news`; sets the pill and bullet colour
- `text`: the always-visible body; Markdown is supported. Keep it to a short lead sentence ending in a period.
- `details`: optional Markdown, typically a bulleted paper list, folded behind a "Read more" toggle
- `people`: optional list of names; each must match a `name` in `_data/people.yml` exactly (any section, including alumni). Matched people with a photo appear as avatars in the tile footer, rendered by `_includes/avatar-strip.html`, which any page can reuse with `{% include avatar-strip.html names=... %}`.
- `url`: optional site-relative or external link that wraps the whole text

Example single-line update:

```yml
- date: "2026-05-01"
  tag: news
  text: "We launched a new seminar page."
  people: ["Ada Lovelace"]
```

Example update with a folded paper list:

```yml
- date: "2026-05-01"
  tag: paper
  text: |
    Two papers by YACL members were accepted to [Example Conf '26](https://example.com).
  details: |
    - [Paper One](https://example.com/paper-1)
    - [Paper Two](https://example.com/paper-2)
  people: ["Ada Lovelace", "Zeyu (Thomas) Liu"]
```

Notes:
- Keep updates in reverse chronological order, newest first.
- Put long lists in `details`, not `text`, so tiles stay short until opened.
- `people` names are matched verbatim, so copy them from `people.yml` (for example `"Zeyu (Thomas) Liu"`, not `"Zeyu Liu"`). Names without a photo are silently skipped.
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

## YAML data validation

Every Jekyll build (including local preview, CI, and deployment) validates all
`_data/*.yml` and `_data/*.yaml` files against the JSON Schemas in `schemas/`.
Invalid content stops the build and reports the file and field path. Run checks
without building the site with:

```bash
bundle exec ruby scripts/validate_data.rb
bundle exec ruby test/validate_data_test.rb
```

Schemas reject unknown fields, missing required fields, incorrect types, blank
required text, malformed dates and email addresses, and duplicate YAML keys.
Dates must be quoted `YYYY-MM-DD` strings. New data files need a matching
`schemas/<name>.schema.json`; update the schema when intentionally changing a
content format. YAML aliases and multiple documents are not supported in data files.

People entries require `name` and optionally accept `email`, `url`, `research`,
and `photo`. Only faculty and visitor sections accept `role`; only alumni
postdoc and alumni student sections accept `affiliation`. PhD student entries
accept neither `role` nor `advisor`. Upcoming seminar titles may be omitted
until announced. Seminar links accept a URL string or an object with `title`
and `url`.

These schemas cover site content in `_data`; Jekyll configuration, GitHub
workflows, and Docker Compose retain their respective tool-defined formats.
