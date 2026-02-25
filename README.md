# Rails Template

A Rails 8.1 template with TypeScript, Devise authentication, Microsoft Entra ID (Azure AD) SSO, and CI/CD configured.

## Prerequisites

- Ruby 3.4+ (see `.ruby-version`)
- Node.js 20+
- Yarn 4+ (via corepack: `corepack enable`)
- PostgreSQL 14+

## Getting Started

### Copying This Template to a New Project

When you fork or copy this template, update **all three** of the following locations to replace `APP_NAME` with your repository name (e.g. `my-app`). They must all match or path-keyed tooling will break.

| File | What to change |
|------|----------------|
| `.devcontainer/devcontainer.json` | `"workspaceFolder": "/workspaces/APP_NAME"` |
| `.devcontainer/docker-compose.yml` | `..:/workspaces/APP_NAME:cached` |
| `.devcontainer/Dockerfile` | `WORKDIR /workspaces/APP_NAME` and the `chown` lines below it |

**Claude Code memory**: Claude Code keys its project memory to the workspace path. A mismatch means memory is silently lost on every rebuild. Fix the path first.

**Claude Code mount** (projects where Claude is approved): Add this to the `mounts` array in `devcontainer.json` so session memory persists across container rebuilds:

```json
"source=${localEnv:HOME}/.claude,target=/home/vscode/.claude,type=bind,consistency=cached"
```

Remove or omit this mount on projects where Claude Code is not an approved tool.

### Option A: Dev Container (Recommended)

The easiest way to get started is using [VS Code Dev Containers](https://code.visualstudio.com/docs/devcontainers/containers) or [GitHub Codespaces](https://github.com/features/codespaces):

1. Open the project in VS Code
2. Click "Reopen in Container" when prompted (or run `Dev Containers: Reopen in Container` from the command palette)
3. Wait for the container to build and dependencies to install
4. Run `bin/dev` to start the development server

The dev container includes Ruby, Node.js, Yarn, and PostgreSQL pre-configured.

A default development user is automatically created:
- **Email**: `dev@example.com`
- **Password**: `password`

### Option B: Local Setup

#### 1. Clone and Setup

```bash
git clone <repo-url>
cd <app-name>
bundle install
yarn install
```

#### 2. Configure Environment Variables

Copy the example environment file and fill in your values:

```bash
cp .env.example .env
```

Required variables:
- `DATABASE_URL` - PostgreSQL connection string

Optional (for Azure SSO):
- `AZURE_CLIENT_ID` - Azure App Registration client ID
- `AZURE_CLIENT_SECRET` - Azure App Registration client secret
- `AZURE_TENANT_ID` - Azure tenant ID

> **Note**: Azure SSO is optional. Without the Azure environment variables, the app uses standard email/password authentication.

#### 3. Setup Azure Entra ID (SSO) - Optional

1. Go to [Azure Portal](https://portal.azure.com/) > Microsoft Entra ID > App registrations
2. Click "New registration"
3. Fill in:
   - Name: Your app name
   - Supported account types: "Accounts in this organizational directory only"
   - Redirect URI: Web, `http://localhost:3000/users/auth/entra_id/callback`
4. After creation, note the **Application (client) ID** and **Directory (tenant) ID**
5. Go to Certificates & secrets > New client secret
6. Copy the secret value (you won't be able to see it again)
7. Add these values to your `.env` file

For production, add the production callback URL to the redirect URIs:
```
https://your-domain.com/users/auth/entra_id/callback
```

#### 4. Setup Database

```bash
bin/rails db:prepare
bin/rails db:seed
```

This creates a development user: `dev@example.com` / `password`

#### 5. Run the Application

```bash
bin/dev
```

Visit `http://localhost:3000`

## Development

### Running Tests

```bash
# Ruby tests (RSpec)
bundle exec rspec              # Run all specs
bundle exec rspec spec/models  # Run model specs only
bundle exec rspec --format doc # Verbose output

# JavaScript tests (Vitest)
yarn test            # Run all tests once
yarn test:watch      # Watch mode for development
```

#### Ruby Testing Stack
- **RSpec** - Testing framework
- **FactoryBot** - Test data factories (`spec/factories/`)
- **SimpleCov** - Code coverage (reports in `coverage/`)
- **VCR/WebMock** - External API mocking

#### TypeScript Testing Stack
- **Vitest** - Fast test runner with native ES modules
- **jsdom** - DOM environment for component testing

Sample tests are provided in:
- `spec/models/user_spec.rb` - Model validations and methods
- `spec/requests/home_spec.rb` - Request/integration tests
- `app/javascript/lib/format.test.ts` - Unit tests
- `app/javascript/controllers/hello_controller.test.ts` - Stimulus controller tests

### Linting

```bash
bin/rubocop          # Ruby linting
yarn lint            # TypeScript/JS linting (Biome)
yarn typecheck       # TypeScript type checking
```

### Formatting

```bash
yarn format          # Format TypeScript/JS with Biome
```

### Security Scanning

```bash
bin/brakeman
```

## CI/CD

### GitHub Actions

The repository includes two workflows:

**ci.yml** - Runs on all PRs and pushes to main:
- Ruby security scanning (Brakeman)
- RuboCop linting
- RSpec tests

**ai-review.yml** - Claude-powered code review ([albersgroup/claude-tool-review-action](https://github.com/albersgroup/claude-tool-review-action)):
- Triggered by adding the `ai-review` label to a PR
- Supports two authentication methods (choose one):
  - **OAuth token** (default) — uses a Claude Max/Pro subscription. Generate with `claude setup-token`
  - **API key** — pay-per-use with an Anthropic API key from [console.anthropic.com](https://console.anthropic.com)

### Setting Up CI Secrets

In your GitHub repository, go to Settings > Secrets and variables > Actions, then add **one** of:
- `CLAUDE_CODE_OAUTH_TOKEN` - OAuth token for Claude Max/Pro subscribers (generate with `claude setup-token`)
- `ANTHROPIC_API_KEY` - Anthropic API key for pay-per-use billing

## Architecture

- **Database**: PostgreSQL
- **Background Jobs**: SolidQueue
- **Cache**: SolidCache (or Memcached for multi-process deployments)
- **CSS**: TailwindCSS
- **JavaScript**: TypeScript with Vite, Hotwire (Turbo + Stimulus)
- **JS Linting**: Biome (replaces ESLint + Prettier)
- **Authentication**: Devise (email/password, with optional Entra ID SSO)
- **Authorization**: CanCanCan

## Project Structure

```
.devcontainer/                           # VS Code Dev Container config
app/
  controllers/
    users/
      omniauth_callbacks_controller.rb   # SSO callback handling
  models/
    user.rb                              # User model with SSO support
  services/                              # Service objects
  queries/                               # Complex database queries
  javascript/
    entrypoints/
      application.ts                     # Vite entry point
    controllers/                         # Stimulus controllers (.ts)
    components/                          # React components (if needed)
    lib/                                 # Shared utilities
spec/
  models/
  requests/
  factories/
Dockerfile                               # Production container
tsconfig.json                            # TypeScript configuration
biome.json                               # Biome linter/formatter config
CLAUDE.md                                # AI coding guidelines
```

## Deployment

### Docker

The application includes a production-ready Dockerfile:

```bash
# Build the image
docker build -t rails-template .

# Run the container
docker run -d -p 80:80 \
  -e RAILS_MASTER_KEY=<value from config/master.key> \
  -e DATABASE_URL=<postgres-url> \
  rails-template
```

### Kamal

[Kamal](https://kamal-deploy.org/) is included for zero-downtime container deployments:

```bash
kamal setup    # First-time server setup
kamal deploy   # Deploy the app
kamal rollback # Roll back to previous version
```

### Dokku (Internal Apps)

```bash
git remote add dokku dokku@your-server:app-name
git push dokku main
```

### AWS Fargate (Commercial Apps)

See internal deployment documentation.

## License

Proprietary - Albers Aerospace
