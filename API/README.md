# API

This work region will focus on the server-side API that connects the
machine-vision algorithm and both the web and mobile application.

## Building

The project is built using Maven. Once you have Maven installed on
your machine, you can build the project using the `mvn clean install`
command. This will create a new directory called `target` which
contains a fat `.jar` which has been statically linked with all
dependencies.

## Invocation

You can invoke the server with the `java -jar eyespy-api.jar` command.