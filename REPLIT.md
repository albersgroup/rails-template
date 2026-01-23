# Rails Template on Replit

This is a Rails 8 template configured to run on Replit. It includes:

- **Rails 8.1.2** with PostgreSQL
- **TypeScript** with Vite for modern frontend development
- **Hotwire** (Turbo + Stimulus) for interactive UIs
- **Tailwind CSS** for styling
- **Devise** for authentication (with optional Azure SSO)
- **RSpec** and **Vitest** for testing

## Quick Start

### 1. Import to Replit

1. Fork or clone this repository to your GitHub account
2. In Replit, click **Create Repl** → **Import from GitHub**
3. Select this repository
4. Replit will automatically detect the configuration and set up the environment

### 2. Configure Database

This template requires PostgreSQL. You have two options:

#### Option A: Use Replit PostgreSQL (Recommended)

1. In your Repl, go to **Tools** → **Database**
2. Select **PostgreSQL**
3. Replit will provision a database and set `DATABASE_URL` automatically

#### Option B: Use External PostgreSQL

1. Set up PostgreSQL on a service like:
   - [Neon](https://neon.tech/) (free tier available)
   - [Supabase](https://supabase.com/) (free tier available)
   - [Railway](https://railway.app/) (free tier available)
2. Copy the connection string
3. Add it to Replit Secrets (see below)

### 3. Set Up Secrets

Go to **Tools** → **Secrets** and add:

#### Required Secrets

- **`DATABASE_URL`**: Your PostgreSQL connection string
  ```
  postgresql://username:password@host:5432/database_name
  ```

  Note: If using Replit PostgreSQL, this is set automatically

#### Optional Secrets

- **`RAILS_MASTER_KEY`**: Required only if you're using encrypted credentials
  - Find this in your local `config/master.key` file
  - Or generate a new one: `bin/rails credentials:edit` (locally)

- **Azure SSO Configuration** (if using Microsoft authentication):
  - `AZURE_CLIENT_ID`: Your Azure App Registration client ID
  - `AZURE_CLIENT_SECRET`: Your Azure App Registration client secret
  - `AZURE_TENANT_ID`: Your Azure AD tenant ID

### 4. Run the Application

1. Click the **Run** button
2. On first run, `bin/replit-setup` will:
   - Install Ruby gems and Node packages
   - Set up the database schema
   - Prepare the environment
3. The development server will start on port 3000

The Run button starts three processes simultaneously:
- Rails server (port 3000)
- Tailwind CSS watcher (hot reload for styles)
- Vite dev server (hot reload for JavaScript/TypeScript)

### 5. Access Your Application

- Click the **Open in new tab** button to view your app
- Or use the Webview panel in Replit

## Development Workflow

### Running Commands

Use the Replit Shell to run Rails commands:

```bash
# Run migrations
bin/rails db:migrate

# Open Rails console
bin/rails console

# Run tests
bin/rspec                 # Ruby tests
yarn test                 # JavaScript tests

# Generate scaffolds
bin/rails generate scaffold Post title:string body:text

# Check code quality
bin/rubocop              # Ruby linting
yarn lint                # JS/TS linting
yarn typecheck           # TypeScript type checking
```

### Project Structure

```
app/
  controllers/          # Rails controllers
  models/               # ActiveRecord models
  views/                # ERB templates
  javascript/
    application.ts      # Main JS entry point
    controllers/        # Stimulus controllers (.ts)
  services/             # Business logic
  queries/              # Complex SQL queries

config/                 # Rails configuration
spec/                   # RSpec tests
bin/                    # Executable scripts
  dev                   # Development server (Foreman)
  replit-setup          # Replit initialization script
```

### Hot Reload

All three development processes support hot reload:

- **Rails**: Code changes take effect on next request
- **Tailwind**: CSS updates instantly
- **Vite**: JavaScript/TypeScript changes update instantly in browser

### Database Management

```bash
# Reset database (WARNING: deletes all data)
bin/rails db:reset

# Seed database
bin/rails db:seed

# View database status
bin/rails db:version

# Create a migration
bin/rails generate migration AddColumnToTable column:type
```

## Using as a Team Template

### For Template Maintainers

1. **Make this a Replit Template**:
   - In your Repl settings, select **Make Template**
   - Configure visibility (Team only recommended)
   - Add template description and tags

2. **Share with Team**:
   - Share the template URL with team members
   - Team members can create new Repls from the template

### For Template Users

1. **Create from Template**:
   - Click the template link
   - Click **Use Template**
   - Give your Repl a name

2. **Configure Your Instance**:
   - Set up your own database (or use Replit PostgreSQL)
   - Add required secrets (DATABASE_URL, etc.)
   - Customize as needed for your project

3. **Deploy Your App**:
   - Click **Deploy** in Replit
   - Configure deployment settings
   - Replit will build and deploy your app

## Troubleshooting

### Database Connection Errors

```
Error: database "xxx" does not exist
```

**Solution**: Ensure `DATABASE_URL` is set correctly in Secrets. Run `bin/rails db:create` in the Shell.

### Asset Compilation Issues

```
Error: Cannot find module 'xxx'
```

**Solution**: Run `yarn install` in the Shell to reinstall packages.

### Port Already in Use

```
Error: Address already in use - bind(2) for 0.0.0.0:3000
```

**Solution**: Stop the current process and restart. Or use the Kill button in Replit.

### Missing Gems

```
Error: Could not find xxx in any of the sources
```

**Solution**: Run `bundle install` in the Shell.

### Credentials Issues

```
Error: Missing encryption key to decrypt file with
```

**Solution**: Add `RAILS_MASTER_KEY` to Replit Secrets, or disable encrypted credentials by removing `config/credentials.yml.enc`.

## Environment Variables Reference

| Variable | Required | Description |
|----------|----------|-------------|
| `DATABASE_URL` | Yes | PostgreSQL connection string |
| `RAILS_MASTER_KEY` | Optional | For encrypted credentials (if using) |
| `RAILS_ENV` | Auto-set | Environment (development/production) |
| `PORT` | Auto-set | Server port (defaults to 3000) |
| `AZURE_CLIENT_ID` | Optional | For Azure SSO |
| `AZURE_CLIENT_SECRET` | Optional | For Azure SSO |
| `AZURE_TENANT_ID` | Optional | For Azure SSO |

## Stack Details

- **Ruby**: 3.4.5
- **Rails**: 8.1.2
- **Node**: 20.x
- **PostgreSQL**: 16
- **Package Manager**: Yarn 4.6.0
- **Test Frameworks**: RSpec (Ruby), Vitest (JavaScript)
- **Authentication**: Devise + OmniAuth
- **Authorization**: CanCanCan
- **Background Jobs**: SolidQueue
- **Caching**: SolidCache
- **WebSockets**: SolidCable

## Learn More

- [Rails Guides](https://guides.rubyonrails.org/)
- [Hotwire Documentation](https://hotwired.dev/)
- [Stimulus Handbook](https://stimulus.hotwired.dev/handbook/introduction)
- [Tailwind CSS Docs](https://tailwindcss.com/docs)
- [TypeScript Handbook](https://www.typescriptlang.org/docs/)
- [Vite Guide](https://vitejs.dev/guide/)

## Support

For issues with this template:
1. Check the Troubleshooting section above
2. Review the main [README.md](README.md)
3. Check [CLAUDE.md](CLAUDE.md) for coding guidelines
4. Contact your team administrator

---

**Note**: This template is configured for development by default. For production deployment, ensure all security best practices are followed (secure secrets, production database, asset precompilation, etc.).
