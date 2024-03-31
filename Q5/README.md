# Question

### Q5 - Reproduce the following spell



https://github.com/LeandroLibanio28H/TavernlightGamesApplication/assets/68310301/ab04d95c-08a4-49d5-945b-920ee881237b


## Solution
You can test the spell by saying the word "frigo" (the same of the provided video).


https://github.com/LeandroLibanio28H/TavernlightGamesApplication/assets/68310301/ce40b613-c48a-4806-81fb-6a126157dbe2



## Considerations
I have never worked with an OTserver or similar before, so it was certainly a very interesting experience that led me to understand a lot about the functioning of TFS and OtClient. 
To accomplish this task, I needed to fix a bug I found in the rendering of effects configured with PatternX: 2 and PatternY: 2. The fix for this rendering issue can be seen in the PR I sent to the GitHub repository:

[Edubart/otclient #1216 PR](https://github.com/edubart/otclient/pull/1216)

I will still take some time to understand why the GitHub checks were not successful, but I can assure you that the solution works on all platforms and for all available special effects.
Meanwhile, the fix is available on the master branch of my forked project:

[Forked Otclient](https://github.com/LeandroLibanio28H/otclient)
