---
title: Teaching
subtitle: Courses offered by YACL faculty
permalink: /teaching/
---

{% for semester in site.data.courses.semesters %}
<div class="semester-block">
  <h2>{{ semester.term }}</h2>
  <table class="table table-striped table-bordered">
    <thead class="table-dark">
      <tr>
        <th>Course</th>
        <th>Title</th>
      </tr>
    </thead>
    <tbody>
      {% for course in semester.courses %}
      <tr>
        <td class="course-table">{% if course.url %}<a href="{{ course.url }}" target="_blank" rel="noopener">{{ course.code }}</a>{% else %}{{ course.code }}{% endif %}</td>
        <td>{{ course.title }}</td>
      </tr>
      {% endfor %}
    </tbody>
  </table>
</div>
{% endfor %}
