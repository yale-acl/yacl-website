---
layout: default
title: Home
---

<section class="home-hero">
  <div class="container">
    <img src="/assets/images/yacl_logo_transparent.png" alt="YACL Logo" class="hero-logo">
    <p class="tagline">We are a group of researchers at Yale working on applied cryptography.</p>
  </div>
</section>

<section class="home-section">
  <div class="container">
    <div class="section-header">
      <h2>Updates</h2>
    </div>
    {% assign all_people = site.data.people.faculty | concat: site.data.people.visitors | concat: site.data.people.postdocs | concat: site.data.people.phd_students | concat: site.data.people.alumni_visitors | concat: site.data.people.alumni_postdocs | concat: site.data.people.alumni_phd_students %}
    {% assign preview_count = site.updates_preview_count | default: 6 %}
    {% assign preview_count_wide = site.updates_preview_count_wide | default: preview_count %}
    {% assign hidden_count = site.data.updates.size | minus: preview_count %}
    <div class="updates-grid is-collapsed" id="updates-grid">
      {% for update in site.data.updates %}
        <article class="update-tile{% if update.tag %} update-tile--{{ update.tag }}{% endif %}{% if forloop.index > preview_count_wide %} update-tile--extra{% elsif forloop.index > preview_count %} update-tile--extra-narrow{% endif %}">
          <div class="update-tile-head">
            <time class="update-date" datetime="{{ update.date }}">{{ update.date | date: "%B %-d, %Y" }}</time>
            {% if update.tag %}<span class="update-tag">{{ update.tag }}</span>{% endif %}
          </div>
          <div class="update-text">
            {%- if update.url -%}
            <p><a href="{{ update.url }}">{{ update.text | markdownify | remove: '<p>' | remove: '</p>' | strip }}</a></p>
            {%- else -%}
            {{ update.text | markdownify }}
            {%- endif -%}
            {%- if update.details -%}
            <details class="update-fold">
              <summary class="fold-summary">
                <span class="fold-label-open"><i class="bi bi-chevron-right"></i>Read more</span>
                <span class="fold-label-close"><i class="bi bi-chevron-down"></i>Show less</span>
              </summary>
              <div class="update-fold-body">{{ update.details | markdownify }}</div>
            </details>
            {%- endif -%}
          </div>
          {%- if update.people -%}
          {%- assign faces = "" | split: "" -%}
          {%- for name in update.people -%}
            {%- assign person = all_people | where: "name", name | first -%}
            {%- if person and person.photo -%}{%- assign faces = faces | push: person -%}{%- endif -%}
          {%- endfor -%}
          {%- if faces.size > 0 -%}
          <div class="update-people" aria-label="People">
            {%- for person in faces -%}
            {%- if person.url -%}<a class="update-face" href="{{ person.url }}" title="{{ person.name }}" target="_blank" rel="noopener"><img src="{{ person.photo }}" alt="{{ person.name }}" loading="lazy"></a>
            {%- else -%}<span class="update-face" title="{{ person.name }}"><img src="{{ person.photo }}" alt="{{ person.name }}" loading="lazy"></span>{%- endif -%}
            {%- endfor -%}
          </div>
          {%- endif -%}
          {%- endif -%}
        </article>
      {% endfor %}
    </div>
    {% if hidden_count > 0 %}
    <button class="updates-toggle" id="updates-toggle">Show all ↓</button>
    {% endif %}
    <script>
    // Masonry: place each tile, in chronological order, into the currently shortest column.
    // The column count comes from the stylesheet's CSS-columns fallback, so breakpoints live in one place.
    (function () {
      var grid = document.getElementById('updates-grid');
      if (!grid) return;
      var tiles = Array.prototype.slice.call(grid.querySelectorAll('.update-tile'));
      function layout() {
        grid.classList.remove('is-masonry');
        var n = parseInt(getComputedStyle(grid).columnCount, 10) || 1, cols = [];
        grid.classList.add('is-masonry');
        grid.innerHTML = '';
        for (var i = 0; i < n; i++) { var c = document.createElement('div'); c.className = 'updates-col'; grid.appendChild(c); cols.push(c); }
        tiles.forEach(function (t) {
          var target = cols[0];
          for (var j = 1; j < cols.length; j++) { if (cols[j].offsetHeight < target.offsetHeight) target = cols[j]; }
          target.appendChild(t);
        });
      }
      var toggle = document.getElementById('updates-toggle');
      if (toggle) toggle.addEventListener('click', function () {
        grid.classList.toggle('is-collapsed');
        toggle.textContent = grid.classList.contains('is-collapsed') ? 'Show all ↓' : 'Show fewer ↑';
        layout();
      });
      layout();
      window.addEventListener('load', layout);
      var timer; window.addEventListener('resize', function () { clearTimeout(timer); timer = setTimeout(layout, 120); });
    })();
    </script>
  </div>
</section>

<section class="home-section alt-bg">
  <div class="container">
    <div class="section-header">
      <h2>Upcoming Seminars</h2>
        <p>To be notified about future talks, register to our <a href="{{ site.mailing_list }}" target="_blank" rel="noopener">mailing list</a> and <a href="{{ site.calendar_embed }}" target="_blank" rel="noopener">calendar</a>.
        To view past talks, check our <a href="{{ site.youtube_archive }}" target="_blank" rel="noopener">YouTube</a>. Interested in giving a talk? Reach out!
        </p>
    </div>
    <div class="seminar-full-list">
      {% assign upcoming = site.data.seminars.upcoming | slice: 0, 3 %}
      {% for talk in upcoming %}
      {% include seminar-card.html talk=talk past=false %}
      {% endfor %}
    </div>

    <a class="d-inline-block mt-2" href="/seminar/">View more upcoming talks &rarr;</a>
  </div>
</section>

<section class="home-section">
  <div class="container">
    <h2 class="mb-3">Connect</h2>
    <p>Join our mailing list for seminar announcements, watch past talks on YouTube, or attend our weekly seminar live.</p>
    <div class="d-flex flex-wrap gap-2 mt-3">
      <a href="{{ site.mailing_list }}" class="btn btn-primary" target="_blank" rel="noopener">Join Mailing List</a>
      <a href="{{ site.youtube_archive }}" class="btn btn-outline-primary" target="_blank" rel="noopener">YouTube Archive</a>
      <a href="mailto:{{ site.email }}" class="btn btn-outline-primary">Contact Us</a>
    </div>
  </div>
</section>
