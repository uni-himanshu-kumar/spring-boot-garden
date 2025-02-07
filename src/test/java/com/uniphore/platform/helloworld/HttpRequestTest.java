package com.uniphore.platform.helloworld;

import org.junit.jupiter.api.Test;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.context.SpringBootTest.WebEnvironment;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.beans.factory.annotation.Value;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest(webEnvironment = WebEnvironment.RANDOM_PORT)
public class HttpRequestTest {

	@Value(value="${local.server.port}")
	private int port;

	@Autowired
	private TestRestTemplate restTemplate;

	@Test
	public void indexShouldReturnDefaultMessage() throws Exception {
		assertThat(this.restTemplate.getForObject("http://localhost:" + port + "/",
				String.class)).contains("{\"hello\":\"world\"}");
	}

	@Test
	public void healthLivenessShouldReturnStatusOK() throws Exception {
		assertThat(this.restTemplate.getForObject("http://localhost:" + port + "/health/liveness",
				String.class)).contains("{\"status\":\"ok\"}");
	}

	@Test
	public void healthReadinessShouldReturnStatusOK() throws Exception {
		assertThat(this.restTemplate.getForObject("http://localhost:" + port + "/health/readiness",
				String.class)).contains("{\"status\":\"ok\"}");
	}
}
