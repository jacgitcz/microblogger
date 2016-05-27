# Microblogger

The Odin Project : Ruby Programming : Ruby on the Web

This implements the Jumpstart Labs Microblogger tutorial.  Note that there is a small error in the
tutorial.  @client.friends does not return a list of user objects, it returns an array of integer user ids - you can then use the id to recover the user object with @client.user(id)