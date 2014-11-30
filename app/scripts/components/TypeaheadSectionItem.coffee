
Mustache = require 'mustache'


class TypeaheadSectionItem

  @template: """
    <p>{{courseCode}} - {{courseName}}</p>
    <p>{{sectionId}}</p>
    <p>{{teacherNames}}</p>
    {{#departments}}
    <p>{{name}}</p>
    {{/departments}}
  """

  @render: (section)=>
    Mustache.render @template, section

module.exports = TypeaheadSectionItem
