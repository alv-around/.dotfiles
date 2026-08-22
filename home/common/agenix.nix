{config, ...}: {
  age = {
    # Point to your unencrypted private key so agenix can decrypt at runtime
    identityPaths = ["${config.home.homeDirectory}/.ssh/id_agenix"];

    secrets = {
      "gemini-key".file = ../secrets/gemini-key.age;
      "claude-key".file = ../secrets/claude-key.age;
      "codex-key".file = ../secrets/codex-key.age;
    };
  };
}
