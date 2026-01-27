# Claude Coding Guidelines

Project-specific instructions for AI coding assistants.

## Stack

- Rails 8 with PostgreSQL
- TypeScript with Vite
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

#### Ruby (RSpec)
- Write RSpec tests for all new code
- Use FactoryBot for test data (see `spec/factories/`)
- Use VCR/WebMock for external API mocking
- Test files mirror app structure in `spec/`
- Use `build(:model)` for validation tests, `create(:model)` when persisting
- Use Devise test helpers: `sign_in user` for request specs
- Aim for 80%+ coverage (SimpleCov reports in `coverage/`)

```ruby
# Model spec example
RSpec.describe User, type: :model do
  it "requires an email" do
    user = build(:user, email: nil)
    expect(user).not_to be_valid
  end
end

# Request spec example
RSpec.describe "Home", type: :request do
  let(:user) { create(:user) }
  before { sign_in user }

  it "returns success" do
    get root_path
    expect(response).to have_http_status(:success)
  end
end
```

#### JavaScript (Vitest)
- Test files use `.test.ts` or `.spec.ts` extension
- Place tests alongside source files or mirror structure
- Use `jsdom` environment for DOM testing
- For Stimulus controllers: set up Application, register controller, test DOM changes

```typescript
// Unit test example
import { describe, expect, it } from "vitest"
import { formatCurrency } from "./format"

describe("formatCurrency", () => {
  it("formats USD", () => {
    expect(formatCurrency(1234.56)).toBe("$1,234.56")
  })
})

// Stimulus controller test example
import { Application } from "@hotwired/stimulus"
import HelloController from "./hello_controller"

beforeEach(() => {
  application = Application.start()
  application.register("hello", HelloController)
  document.body.innerHTML = `<div data-controller="hello"></div>`
})
```

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

## Replit Specifics
- **User Preference**: Preferred communication style is simple, everyday language.
- **Backend Architecture**: Rails 8.1 template.
- **Frontend Architecture**: TailwindCSS compiled from `app/assets/tailwind/application.css`.
- **Environment**: PostgreSQL 14+ primary database, connection via `DATABASE_URL`.
