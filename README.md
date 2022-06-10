# Kotlin compiler server

Compiler server - forked from the kotlin compiler server, one thing to note is that the configuration 
at `https://github.com/Safetorun/safeToRunConfiguration` - you can shadowbuild that, and put the shadowJar 
1.6.21 folder, then deploy that. 

This is probably not the right way of doing it, but after 2 weeks of getting annoyed by missing dependencies
on things like kotlinx serialization ... I got fed up and did this instead.

Post deployment, CORS is **still** not working - so you need to go into API Gateway, add CORS and then re-deploy
