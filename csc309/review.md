# Week 4: JS Events

## Event Loop
JavaScript is **single-threaded** which means that it only runs one thing at a time. It implements the **Asynchronous** property by using the **event loop**.

**Event loop** is a way of scheduling events one after the other. It consists of **call stack**, **web APIs** and **callback queue**. 

---
### Visual representation
<img src="images/event_loop.png" width=200px>

---
### Stack

```JavaScript
function foo(b) {
    var a = 10;
    return a + b + 11;
}

function bar(x) {
    var y = 3;
    return foo(x * y);
} 

console.log(bar(7));
```
When calling `bar()`, a first frame is created containing the *arguments* and *local variables*. When `bar()` calls `foo()`, a second frame is created and pushed on top of the first one containing `foo()`'s arguments and local variables. When `foo()` returns, the top frame element is popped out of the stack (leaving only `bar()`'s call frame). When `bar()` returns, the stack is empty.

---
### Heap
**Objects** are allocated in a heap which is just a name to denote a large mostly unstructured region of memory.

---
### Queue
A JavaScript runtime uses a message queue, which is a list of messages to be processed. Each message has an associate function which gets called in order to handle the message.

At some point during the event loop, the runtime starts handling the messages on the queue, starting with the **oldest** one. To do so, the message is removed from the queue and its corresponding function is called with the message as an input parameter. As always, calling a function creates a **new stack frame** for that function's use.

The processing of functions **continues until the stack is once again empty** then the event loop will process the next message in the queue (if there is one). 

---
### "Run-to-completion"
Each message is processesd completely before any other message is processed i.e. whenever a function runs, it cannot be pre-empted and will run entirely before any other code runs.

A downside of this model is that if a message takes too long to complete, the web application is unable to process user interactions like click or scroll.


---
# Week 7: Back-end programming
Back-end programming involves:
- Communicating with servers, databases (obtaining and manipulating web resources).
- Running the programs that can't easily be run on a client and machine, e.g. complex calculations, fast computation, data storage/persistence and retrieval.