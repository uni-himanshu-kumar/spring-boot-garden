package com.uniphore.platform.helloworld;

import java.util.Map;

import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloWorldController {
	private final HelloWorldService service;

	public HelloWorldController(HelloWorldService service) {
		this.service = service;
	}

	@GetMapping(value="/", produces=MediaType.APPLICATION_JSON_VALUE)
	public Map<String,String> index() {
		return service.greet();
	}

	@GetMapping(value="/health/liveness", produces=MediaType.APPLICATION_JSON_VALUE)
	public Map<String,String> healthLiveness() {
		return Map.of("status", "ok");
	}

	@GetMapping(value="/health/readiness", produces=MediaType.APPLICATION_JSON_VALUE)
	public Map<String,String> healthReadiness() {
		return Map.of("status", "ok");
	}
}
