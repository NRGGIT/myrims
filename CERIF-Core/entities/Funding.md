# Funding

## Definition
Money provided by an organization or government for a particular purpose.<sup>[1](#fn1)</sup>

## Usage notes
Fundings typically make up hierarchies, where the breakdown follows various criteria such as funding source, cost type, or fiscal terms.

Like any other [Resource](../entities/Resource.md), Funding can be [offered](../entities/Resource_Offer.md), [requested](../entities/Resource_Request.md), [provided](../entities/Contribution_Statement.md) or actually [used](../entities/Resource_Usage_Statement.md).

## Specialization of
[Resource](../entities/Resource.md)

## Attributes
Those of [Resource](../entities/Resource.md) plus:

amount : [Monetary Amount](../datatypes/Monetary_Amount.md)

## Relationships
Those of [Resource](../entities/Resource.md) plus:

<a name="rel__covers">covers</a> / [is-covered-by](../entities/Activity.md#user-content-rel__is-covered-by) : A Funding can cover any number of [Activities](../entities/Activity.md).

<a name="rel__covers">covers</a> / [funded-by](../entities/Project.md#user-content-rel__funded-by) : A Funding can cover any number of [Projects](../entities/Project.md) that help it happen.

---
## References
<a name="fn1">\[1\]</a> Source: The Oxford Learner's Dictionary of Academic English, https://www.oxfordlearnersdictionaries.com/definition/academic/funding
