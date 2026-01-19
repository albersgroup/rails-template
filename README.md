# Rails Template

A Rails 8.1 template with TypeScript, Devise authentication, Microsoft Entra ID (Azure AD) SSO, and CI/CD configured.

## Prerequisites

- Ruby 3.4+ (see `.ruby-version`)
- Node.js 20+
- Yarn 4+ (via corepack: `corepack enable`)
- PostgreSQL 14+

## Getting Started

### 1. Clone and Setup

```bash
git clone <repo-url>
cd <app-name>
bundle install
yarn install
```

### 2. Configure Environment Variables

Copy the example environment file and fill in your values:

```bash
cp .env.example .env
```

Required variables:
- `DATABASE_URL` - PostgreSQL connection string
- `AZURE_CLIENT_ID` - Azure App Registration client ID
- `AZURE_CLIENT_SECRET` - Azure App Registration client secret
- `AZURE_TENANT_ID` - Azure tenant ID

### 3. Setup Azure Entra ID (SSO)

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

### 4. Setup Database

```bash
bin/rails db:create
bin/rails db:migrate
```

### 5. Run the Application

```bash
bin/dev
```

Visit `http://localhost:3000`

## Development

### Running Tests

```bash
bundle exec rspec    # Ruby tests
yarn test            # JavaScript tests
```

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

**ai-review.yml** - Claude-powered code review:
- Triggered by adding the `ai-review` label to a PR
- Requires `ANTHROPIC_API_KEY` secret in repository settings

### Setting Up CI Secrets

In your GitHub repository, go to Settings > Secrets and variables > Actions, then add:
- `ANTHROPIC_API_KEY` - Your Anthropic API key (for AI code reviews)

## Architecture

- **Database**: PostgreSQL
- **Background Jobs**: SolidQueue
- **Cache**: SolidCache (or Memcached for multi-process deployments)
- **CSS**: TailwindCSS
- **JavaScript**: TypeScript with esbuild, Hotwire (Turbo + Stimulus)
- **JS Linting**: Biome (replaces ESLint + Prettier)
- **Authentication**: Devise with Entra ID SSO
- **Authorization**: CanCanCan

## Project Structure

```
app/
  controllers/
    users/
      omniauth_callbacks_controller.rb  # SSO callback handling
  models/
    user.rb                              # User model with SSO support
  services/                              # Service objects
  queries/                               # Complex database queries
  javascript/
    application.ts                       # Entry point
    controllers/                         # Stimulus controllers (.ts)
    components/                          # React components (if needed)
    lib/                                 # Shared utilities
spec/
  models/
  requests/
  factories/
tsconfig.json                            # TypeScript configuration
biome.json                               # Biome linter/formatter config
CLAUDE.md                                # AI coding guidelines
```

## Deployment

### Dokku (Internal Apps)

```bash
git remote add dokku dokku@your-server:app-name
git push dokku main
```

### AWS Fargate (Commercial Apps)

See internal deployment documentation.

## License

Proprietary - Albers Group
