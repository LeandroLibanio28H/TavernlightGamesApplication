# Question

### Q6 - Reproduce the Dash spell (shader)




https://github.com/LeandroLibanio28H/TavernlightGamesApplication/assets/68310301/24a00bfd-7d2f-4e87-91d5-da78a5f3e21d




## Solution
To perform the dash, I applied two approaches: one consists of a spell, and the other is a movement performed by the client. 
The spell can be cast by saying the words "utani dash hur", but unfortunately, the shader will not be applied if the spell is cast in this way. 
To address this, a module was created in the otclient that causes the spell to be cast by pressing the F2 key. Pressing the F1 key will execute the client-side dash effect. 

_By using the commands above, the shader will be reproduced_

https://github.com/LeandroLibanio28H/TavernlightGamesApplication/assets/68310301/3a175c17-b9c5-4904-8cd9-e6eb8d08b2ad

### Changes to source code
To resolve this question, I made some changes to the client's source code, which can be found at the following link:

[Forked Otclient commit](https://github.com/LeandroLibanio28H/otclient/commit/3e42bfbb0d5ca6251fb64b761e7bf600dc22801c)

I won't be opening a pull request for this case, as it's very specific. I simply made the commit so that it's easy to compare the changes made. You can use the compiled client sent along with the test, or compile the client from this commit on my fork.

## Considerations
I had never worked with shaders before, everything I did here was learned from scratch during the test. 
This was the activity that took me the most time; I spent about 4 days on it. 
I'm sure there is a better way to do everything shown here, but this was the best I could do. 
I am willing to continue studying to improve in this aspect.
The version available in the _client folder will be without comments since, with comments, it doesn't work (I don't know why).

