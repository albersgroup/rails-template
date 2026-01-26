# Rails Template

## Overview

A Rails 8.1 web application template with TypeScript frontend, Devise authentication, and optional Microsoft Entra ID (Azure AD) SSO integration. The project uses Hotwire (Turbo + Stimulus) for interactive UIs without heavy JavaScript frameworks, Vite for modern frontend bundling, and TailwindCSS for styling.

## User Preferences

Preferred communication style: Simple, everyday language.

## System Architecture

### Backend Architecture
- **Framework**: Rails 8.1 with PostgreSQL database
- **Pattern**: Standard Rails MVC with thin controllers and focused models
- **Business Logic**: Complex logic goes in `app/services/`, complex queries in `app/queries/`
- **Authentication**: Devise gem handles user authentication with optional Azure AD SSO
- **Code Style**: RuboCop enforces Ruby style conventions (`bin/rubocop`)

### Frontend Architecture
- **Bundler**: Vite with `vite-plugin-rails` for asset compilation
- **Language**: TypeScript in strict mode (`app/javascript/`)
- **Interactivity**: Hotwire stack (Turbo for navigation, Stimulus for DOM manipulation)
- **Styling**: TailwindCSS compiled from `app/assets/tailwind/application.css`
- **Linting**: Biome for JavaScript/TypeScript linting and formatting
- **Escalation Path**: Consider React only for complex state management, heavy real-time updates, or reusable component libraries

### Testing Strategy
- **Ruby Tests**: RSpec with FactoryBot for test data, VCR/WebMock for API mocking
- **JavaScript Tests**: Vitest with jsdom environment
- **Coverage**: SimpleCov reports to `coverage/` directory, targeting 80%+ coverage
- **Test Location**: Ruby specs mirror app structure in `spec/`, JS tests colocated with source files

### Key Commands
- `bin/dev` - Start development server
- `bin/rubocop` - Run Ruby linter
- `yarn typecheck` - Verify TypeScript types
- `yarn lint` / `yarn format` - Run Biome linting and formatting
- `yarn test` - Run Vitest frontend tests

## External Dependencies

### Database
- **PostgreSQL 14+**: Primary database, connection via `DATABASE_URL` environment variable

### Frontend Packages
- `@hotwired/stimulus`: JavaScript framework for Stimulus controllers
- `@hotwired/turbo-rails`: Turbo integration for Rails
- `vite` + `vite-plugin-rails`: Modern frontend bundling

### Development Tools
- `@biomejs/biome`: JavaScript/TypeScript linting and formatting
- `vitest`: Frontend testing framework
- `typescript`: Type checking for frontend code

### Optional Integrations
- **Microsoft Entra ID (Azure AD)**: SSO authentication (requires configuration in environment variables)

### Environment Variables
- `DATABASE_URL` (required): PostgreSQL connection string