# Event

## Definition

A thing that happens, especially something important.<sup>[1](#fn1)</sup>

## Usage notes

Events include scientific and other conferences, workshops, seminars or any other type of meeting. 
It can be one particular event, for instance the [CRIS 2024](https://doi.org/10.25798/9mpv-rg74) conference.

## Attributes

title : [Multilingual String](../datatypes/Multilingual_String.md)

acronym : [Multilingual String](../datatypes/Multilingual_String.md)

description : [Multilingual String](../datatypes/Multilingual_String.md)

dateRange : [Date Range](../datatypes/Date_Range.md)

ordinal number: [Decimal](../datatypes/Decimal.md)

contacts : List<[Contact_Information](../datatypes/Contact_Information.md)>

## Relationships

<a name="rel__has-contribution">has-contribution</a> / [has-target](../entities/Contribution_to_Event.md#user-content-rel__has-target) : An Event can have any number of [contributions](../entities/Contribution_to_Event.md) that helped it take place or arise.

<a name="rel__collocated-with">collocated-with</a> : An Event can be collocated with the another [Events](../entities/Event.md).

<a name="rel__belongs-to-series">belongs-to-series</a> / [has-instances](../entities/Event_Series.md#user-content-rel__has-instances) : An Event can be an instance of [Event Series](../entities/Event_Series.md).

<a name="rel__awarded-by">awarded-by</a> / [awarded-for-an-event](../entities/Prize_Award.md#user-content-rel__awarded-for-an-event) : An Event can be awarded by a [Prize Award](../entities/Prize_Award.md).


---
## Matches
Narrow match of Schema.org [Event](https://schema.org/Event).

## References
<a name="fn1">\[1\]</a> Source: The Cambridge Dictionary of English. https://www.oxfordlearnersdictionaries.com/definition/english/event