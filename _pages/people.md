---
title: People
subtitle: Faculty, students, and researchers at YACL
permalink: /people/
---

<div class="page-section">
  <h2>Faculty</h2>
  <div class="people-list">
    {% for person in site.data.people.faculty %}
      {% include person.html person=person subtitle=person.role subtitle_class="person-role" %}
    {% endfor %}
  </div>
</div>

<div class="page-section">
  <h2>Visitors</h2>
  <div class="people-list">
    {% for person in site.data.people.visitors %}
      {% include person.html person=person subtitle=person.role %}
    {% endfor %}
  </div>
</div>

{% if site.data.people.postdocs and site.data.people.postdocs.size > 0 %}
<div class="page-section">
  <h2>Postdoctoral Researchers</h2>
  <div class="people-list">
    {% for person in site.data.people.postdocs %}
      {% include person.html person=person %}
    {% endfor %}
  </div>
</div>
{% endif %}

<div class="page-section">
  <h2>PhD Students</h2>
  <div class="people-grid">
    {% for person in site.data.people.phd_students %}
      {% include person.html person=person layout="card" %}
    {% endfor %}
  </div>
</div>

<div class="page-section">
  <h2>Alumni (Visitors)</h2>
  <div class="people-list">
    {% for person in site.data.people.alumni_visitors %}
      {% include person.html person=person subtitle=person.role %}
    {% endfor %}
  </div>
</div>

<div class="page-section">
  <h2>Alumni (Postdocs)</h2>
  <div class="people-grid">
    {% for person in site.data.people.alumni_postdocs %}
      {% include person.html person=person layout="card" subtitle=person.affiliation %}
    {% endfor %}
  </div>
</div>

<div class="page-section">
  <h2>Alumni (Students)</h2>
  <div class="people-grid">
    {% for person in site.data.people.alumni_phd_students %}
      {% include person.html person=person layout="card" subtitle=person.affiliation %}
    {% endfor %}
  </div>
</div>
