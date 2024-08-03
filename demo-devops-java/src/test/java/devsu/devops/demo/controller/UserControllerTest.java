package devsu.devops.demo.controller;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.web.servlet.MockMvc;

@AutoConfigureMockMvc
@SpringBootTest
@DisplayName("User controller")
public class UserControllerTest {

	@Autowired
	private MockMvc mockMvc;

	private final String relativePath = "/users";
    private final String relativePathGetID = "/users/{id}";

	@Test
	@DisplayName("GET: " + relativePath + ": ✔ Status code 200")
	void getUsers_statusOk() throws Exception {
		mockMvc.perform(
				get(relativePath)
				.characterEncoding("utf-8")
				)
		.andExpect(status().isOk());
	}

    @Test
    @DisplayName("GET: " + relativePathGetID + ": ✔ Status code 200")
    void getUser_statusOk() throws Exception {
        mockMvc.perform(
                get(relativePathGetID, 1)
                        .characterEncoding("utf-8")
        )
                .andExpect(status().isOk());
    }
}
