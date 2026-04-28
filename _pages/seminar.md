---
title: Seminar
subtitle: Weekly cryptography and security talks — Fridays at 11am ET
layout: page
permalink: /seminar/
---

<p>To be notified about future talks, register to our <a href="{{ site.mailing_list }}" target="_blank" rel="noopener">mailing list</a> and <a href="{{ site.calendar_embed }}" target="_blank" rel="noopener">calendar</a>.
To view past talks, check our <a href="{{ site.youtube_archive }}" target="_blank" rel="noopener">YouTube</a>. Interested in giving a talk? Reach out!</p>

<h2>Upcoming Talks</h2>
<div class="seminar-full-list">
  {% for talk in site.data.seminars.upcoming %}
    {% include seminar-card.html talk=talk past=false %}
  {% endfor %}
</div>

<h2>Past Talks</h2>
<div class="seminar-full-list">
  {% for talk in site.data.seminars.past %}
    {% include seminar-card.html talk=talk past=true %}
  {% endfor %}
</div>

<h2>Resources</h2>
<p>Join our mailing list for seminar announcements, watch past talks on YouTube, or attend our weekly seminar live via Zoom.</p>
<div class="d-flex flex-wrap gap-2 mt-3">
  <a href="{{ site.mailing_list }}" class="btn btn-primary" target="_blank" rel="noopener"><i class="bi bi-envelope me-1"></i>Join Mailing List</a>
  <a href="{{ site.youtube_archive }}" class="btn btn-outline-primary" target="_blank" rel="noopener"><i class="bi bi-youtube me-1"></i>YouTube Archive</a>
  <a href="{{ site.zoom_link }}" class="btn btn-outline-primary" target="_blank" rel="noopener"><i class="bi bi-camera-video me-1"></i>Zoom Livestream</a>
  <a href="{{ site.calendar_embed }}" class="btn btn-outline-primary" target="_blank" rel="noopener"><i class="bi bi-calendar3 me-1"></i>Google Calendar</a>
  <a href="mailto:{{ site.email }}" class="btn btn-outline-primary"><i class="bi bi-chat me-1"></i>Contact Us</a>
</div>
