# Claude Coding Guidelines

Project-specific instructions for AI coding assistants.

## Stack

- Rails 8 with PostgreSQL
- TypeScript with esbuild
- Hotwire (Turbo + Stimulus) for interactivity
- TailwindCSS for styling
- Biome for JS/TS linting and formatting
- RSpec for testing

## Code Style

### Ruby

- Follow Rails conventions and idioms
- Keep controllers thin, models focused
- Extract complex business logic to service objects in `app/services/`
- Extract complex queries to `app/queries/`
- Use RuboCop for style enforcement (run `bin/rubocop`)

### TypeScript

- All frontend code is TypeScript (strict mode enabled)
- Use Stimulus controllers for DOM manipulation
- Controller files go in `app/javascript/controllers/` with `.ts` extension
- Run `yarn typecheck` to verify types
- Run `yarn lint` for Biome linting, `yarn format` for formatting

**When to escalate to React:**
- Complex client-side state management
- Heavy real-time UI updates
- Deeply nested controller interactions
- Reusable component libraries

### Testing

- Write RSpec tests for all new code
- Use FactoryBot for test data
- Use VCR/WebMock for external API mocking
- Test files mirror app structure in `spec/`
- Aim for 80%+ coverage

## Patterns

### Authentication

- Devise handles authentication
- SSO via Microsoft Entra ID (Azure AD)
- Check authentication with `authenticate_user!` before_action
- Access current user with `current_user`

### Authorization

- CanCanCan for authorization
- Define abilities in `app/models/ability.rb`
- Check permissions with `authorize!` or `can?`

### APIs

- Document all APIs with OpenAPI specification
- Prefer JSON:API format for REST endpoints
- Keep API controllers in `app/controllers/api/`

### Background Jobs

- Use ActiveJob with SolidQueue
- Jobs go in `app/jobs/`
- Keep jobs small and idempotent

## File Organization

```
app/
  controllers/          # Keep thin, delegate to services
  models/               # ActiveRecord models, validations, scopes
  services/             # Business logic (e.g., UserRegistrationService)
  queries/              # Complex SQL queries (e.g., ReportQuery)
  jobs/                 # Background jobs
  javascript/
    application.ts      # Entry point
    controllers/        # Stimulus controllers (.ts)
    components/         # React components (if used)
    lib/                # Shared utilities
spec/
  models/
  requests/
  services/
  factories/
```

## Commit Style

- Use conventional commits: `feat:`, `fix:`, `docs:`, `refactor:`, `test:`
- Present tense, imperative mood ("Add feature" not "Added feature")
- Keep commits focused on single changes

## Security

- Never commit secrets or credentials
- Use Rails credentials for encrypted secrets
- Validate all user input
- Use parameterized queries (Rails default)
- Run `bin/brakeman` to check for vulnerabilities

## Don'ts

- Don't add unnecessary abstractions or "future-proofing"
- Don't over-engineer simple features
- Don't add comments that just restate the code
- Don't commit `.env` files or credentials
- Don't skip tests for "simple" changes
