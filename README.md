# Specification Pattern

## Pattern description

> The central idea of
Specification
 is to separate the statement of how to match a candidate, from the
candidate object that it is matched against. As well as its usefulness in selection, it is also valuable for
validation and for building to order.

[Specification paper by Evans and Fowler](http://martinfowler.com/apsupp/spec.pdf)

## Problem

The statement of a bank account includes multiple transactions. We may want to select transaction based on different criteria like the amount, the type or the value date. In addition we may want to select transactions with an arbitrary combination of criteria.
