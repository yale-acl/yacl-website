---
title: People
subtitle: Faculty, students, and researchers at YACL
permalink: /people/
---

<div class="people-section">
  <h2>Faculty</h2>
  <div class="faculty-grid">
    {% for person in site.data.people.faculty %}
    <div class="person-card">
      <img class="person-photo" src="{{ person.photo | default: site.data.people.placeholder }}" alt="{{ person.name }}">
      <div class="person-info">
        <h3>{% if person.url and person.url != "" %}<a href="{{ person.url }}">{{ person.name }}</a>{% else %}{{ person.name }}{% endif %}</h3>
        <p class="person-role">{{ person.role }}</p>
        <p class="person-research">{{ person.research }}</p>
      </div>
    </div>
    {% endfor %}
  </div>
</div>

<div class="people-section">
  <h2>Postdoctoral Researchers</h2>
  <div class="member-grid">
    {% for person in site.data.people.postdocs %}
    <div class="member-card">
      <img class="member-photo" src="{{ person.photo | default: site.data.people.placeholder }}" alt="{{ person.name }}">
      <span class="member-name">{{ person.name }}</span>
    </div>
    {% endfor %}
  </div>
</div>

<div class="people-section">
  <h2>PhD Students</h2>
  <div class="member-grid">
    {% for person in site.data.people.phd_students %}
    <div class="member-card">
      <img class="member-photo" src="{{ person.photo | default: site.data.people.placeholder }}" alt="{{ person.name }}">
      <span class="member-name">{{ person.name }}</span>
    </div>
    {% endfor %}
  </div>
</div>

<div class="people-section">
  <h2>Visitors</h2>
  <div class="member-grid">
    {% for person in site.data.people.visitors %}
    <div class="member-card">
      <img class="member-photo" src="{{ person.photo | default: site.data.people.placeholder }}" alt="{{ person.name }}">
      <span class="member-name">{{ person.name }}</span>
      {% if person.role %}<span class="member-role">{{ person.role }}</span>{% endif %}
    </div>
    {% endfor %}
  </div>
</div>

<div class="people-section">
  <h2>Alumni</h2>
  <div class="member-grid">
    {% for person in site.data.people.alumni %}
    <div class="member-card">
      <img class="member-photo" src="{{ person.photo | default: site.data.people.placeholder }}" alt="{{ person.name }}">
      <span class="member-name">{{ person.name }}</span>
      {% if person.affiliation and person.affiliation != "" %}<span class="member-role">{{ person.affiliation }}</span>{% endif %}
    </div>
    {% endfor %}
  </div>
</div>
