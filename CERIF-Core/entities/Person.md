# Person

## Definition
A human being as an individual.<sup>[1](#fn1)</sup>

## Usage notes
The kind of involvement of a Person in the research ecosystem is specified in the links with the organisations, the services, etc. This typically includes:
1. researchers (Persons performing research in an Organisation Unit as employees or students);
2. authors and other contributors (Persons signing a publication, creators of data sets, software developers, etc.);
3. investigators and project participants (Persons involved in a Project as principal investigators, co investigators, project managers, consultants, etc.);
4. management (directors, rectors, deans, department heads, etc.);
5. support staff (technicians, responsible for Equipment, librarians and digital asset curators, administrative staff, etc.).

One Person typically has many of these relationships.

## Specialization of
[Agent](../entities/Agent.md)

## Attributes
Those of [Agent](../entities/Agent.md#relationships) plus:

name            : [Person Name](../datatypes/Person_Name.md)

alternate names : List<[Person Name](../datatypes/Person_Name.md)>

## Relationships
Those of [Agent](../entities/Agent.md#relationships) plus:

<a name="rel__is-the-person-in">is-the-person-in</a> / [has-person](../entities/Affiliation_Statement.md#user-content-rel__has-person) : A Person can be the person in any number of [Affiliation Statements](../entities/Affiliation_Statement.md).

---
## Matches
1. Close match of [FOAF Person](http://xmlns.com/foaf/spec/#term_Person) (identified by URI http://xmlns.com/foaf/0.1/Person), which is also used in VIVO
2. Narrow match of [Schema.org Person](https://schema.org/Person)

## References
<a name="fn1">\[1\]</a> Source: The Oxford Dictionary, https://en.oxforddictionaries.com/definition/person
