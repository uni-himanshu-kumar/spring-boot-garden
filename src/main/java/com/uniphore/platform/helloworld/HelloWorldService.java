package com.uniphore.platform.helloworld;

import java.util.Map;

import org.springframework.stereotype.Service;

@Service
public class HelloWorldService {
	public Map<String,String> greet() {
		return Map.of("hello", "world");
	}
}
