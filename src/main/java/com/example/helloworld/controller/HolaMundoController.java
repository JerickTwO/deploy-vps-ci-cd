package com.example.helloworld.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HolaMundoController {

    @GetMapping("/")
    public String holaMundo() {
        return "¡Hola Mundo desde Spring Boot!";
    }

    @GetMapping("/hola")
    public String hola() {
        return "¡Hola! Bienvenido a nuestra aplicación";
    }

    @GetMapping("/saludo")
    public String saludo() {
        return "¡Saludos desde el controlador!";
    }
}
