# Local Docker build

The React 15 test helpers use react-dom/test-utils. Do not reinstall the incompatible
react-addons-test-utils 0.14 package or bypass peer dependency validation.

Run the existing tests before deployment:

    docker build --target test -t awesome-web-cv:test .

Build and start the static site:

    docker build -t awesome-web-cv:local .
    docker run -d --name awesome-web-cv-local -p 127.0.0.1:9198:8080 awesome-web-cv:local

Check container health and open http://127.0.0.1:9198/.
The runtime serves the compiled dist/main.js bundle and repository CSS/JSON with nginx.
The webpack development server's hardcoded port 9999 is not used for deployment.

For the orchestrator, register a NEW managed service such as awesome-web-cv-v2 after these
changes have been reviewed and pushed. Use the root Dockerfile, profile docker, container_port
8080, test_target test and staging host port 9198. Existing catalog recipes are retained, so
reusing the old service name would reuse its old generated files.

The one existing application test is a render smoke test; it does not provide full UI coverage.
This repair retains the application's legacy React/webpack libraries rather than modernizing
the entire frontend.
