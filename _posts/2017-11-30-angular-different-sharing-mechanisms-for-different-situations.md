---
layout: post
title: "[Angular] Different sharing mechanisms for different situations"
categories:
    - Development
tags:
    - Angular
    - WebApp
---
Angular has different mechanisms for sharing data between components. The choice of the sharing method mostly depends on the relationship of the related components. Typically, within the context of a parent-child topology, the most straightforward choice would be to use the `@Input` and `@Output` decorators. For sibling components, relying on a data sharing service seems to be the most obvious solution. In any case, once you have settled on the choice of a communication topology, you need to decide which data propagating mechanism to use.

Generally, components use `EventEmmiter` objects to share data with each other. When you pass data into an Angular component with an `@Input` decorator, you are actually using an `EventEmitter` object. Although this solution is appropriate for the majority of situations, this is not always the case. Let's consider the following example:

![Diagram of the data propagation using an EventEmitter][eventemitter-diag]

<!--more-->

An emitter component fires an event when a certain situation happens using an `EventEmitter` object. The event is designed to be received by the two receivers. These two components are independent from each other and they are controlled by a router which means that only one of them is executed at once. However, we want both receivers to be able to process the latest version of the shared data sent by the emitter component. The problem here is that the emitter sends its data only once as soon as the trigger event is fired. Only the active receiver will receive the shared data.

Below is an interactive demo of this example:

<iframe style="width: 100%; height: 600px" src="http://embed.plnkr.co/fZbjw7?show=preview" frameborder="0" allowfullscren="allowfullscren"></iframe>

A sidebar component (the emitter) contains a drop-down menu with different value choices. When a user selects one or more of these choices, the related values are sent to the currently displayed receiver (receiver 1 at start-up). The displayed receiver is nested inside a router component. Since only one of the components controlled by the router is executed at once, the drop-down menu's values are not propagated when the user decides to display the second receiver by clicking on the second tab. Consequently, the user's input selection is lost, even when going back and forth from receiver 1 to receiver 2.

Angular's sharing mechanisms rely on the [ReactiveX library][rxjs]. The [EventEmitter definition][eventemitter] extends the ReactiveX library's `Subject` class:

    class EventEmitter<T> extends Subject {
      ...
    }

As a result, any of the [varieties of Subject][subjects] is suitable to be used instead of `EventEmitter`. For the present use case, a `ReplaySubject` object with a buffer size of 1 seems to be a good solution to solve the issue previously described. That way, the latest version of the shared data sent by the emitter will be sent again each time a new receiver will subscribe to its data stream:

![Diagram of the data propagation using a ReplaySubject][replaysubject-diag]

See the result for yourself:

<iframe style="width: 100%; height: 600px" src="http://embed.plnkr.co/sJYnOO?show=preview" frameborder="0" allowfullscren="allowfullscren"></iframe>

As you can see, the communication topology is not the only thing to think about when designing the software architecture of your Angular application. Take the time to read about the different [Subject classes][subjects] from the [ReactiveX library][rxjs] before implementing your own homemade solution.

 [eventemitter]: https://angular.io/api/core/EventEmitter
 [eventemitter-diag]: /images/EventEmitter.svg "Diagram of the data propagation using an EventEmitter"
 [rxjs]: http://reactivex.io/
 [replaysubject-diag]: /images/ReplaySubject.svg "Diagram of the data propagation using a ReplaySubject"
 [subjects]: http://reactivex.io/documentation/subject.html
