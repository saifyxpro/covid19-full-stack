# 🤝 Contributing to COVID-19 Full Stack Application

**Project Maintainer:** [Saify (@saifyxpro)](https://github.com/saifyxpro)  
**Repository:** https://github.com/saifyxpro/covid19-full-stack  
**Version:** 2.0.0 (2025)

First off, thank you for considering contributing to the COVID-19 Full Stack Application! 🎉

This document provides guidelines for contributing to this project. Following these guidelines helps maintain the quality and consistency of the codebase while making the contribution process smooth for everyone.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Getting Started](#getting-started)
- [Development Process](#development-process)
- [Pull Request Guidelines](#pull-request-guidelines)
- [Coding Standards](#coding-standards)
- [Testing Guidelines](#testing-guidelines)
- [Documentation](#documentation)
- [Community](#community)

## 🌟 Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code. Please report unacceptable behavior to the project maintainer [Saify (@saifyxpro)](https://github.com/saifyxpro).

### Our Pledge

We pledge to make participation in our project a harassment-free experience for everyone, regardless of:
- Age, body size, disability, ethnicity
- Gender identity and expression
- Level of experience, nationality
- Personal appearance, race, religion
- Sexual identity and orientation

### Our Standards

**Positive behavior includes:**
- ✅ Using welcoming and inclusive language
- ✅ Being respectful of differing viewpoints
- ✅ Gracefully accepting constructive criticism
- ✅ Focusing on what is best for the community
- ✅ Showing empathy towards other community members

**Unacceptable behavior includes:**
- ❌ Trolling, insulting/derogatory comments, personal attacks
- ❌ Public or private harassment
- ❌ Publishing private information without permission
- ❌ Other conduct inappropriate in a professional setting

## 🚀 How Can I Contribute?

### 🐛 Reporting Bugs

Before creating bug reports, please check the [existing issues](https://github.com/saifyxpro/covid19-full-stack/issues) to avoid duplicates.

**How to Submit a Bug Report:**

1. **Use a clear and descriptive title**
2. **Describe the exact steps to reproduce the problem**
3. **Provide specific examples and screenshots**
4. **Describe the behavior you observed and what you expected**
5. **Include details about your environment:**
   - OS: Windows 10, macOS Monterey, Ubuntu 20.04
   - Node.js version: 16.14.0
   - Browser: Chrome 96, Firefox 95, Safari 15
   - MongoDB version: 5.0.3

**Bug Report Template:**
```markdown
## Bug Description
A clear and concise description of what the bug is.

## Steps to Reproduce
1. Go to '...'
2. Click on '....'
3. Scroll down to '....'
4. See error

## Expected Behavior
A clear description of what you expected to happen.

## Screenshots
If applicable, add screenshots to help explain your problem.

## Environment
- OS: [e.g. Windows 10]
- Node.js: [e.g. 16.14.0]
- Browser: [e.g. Chrome 96]
- MongoDB: [e.g. 5.0.3]

## Additional Context
Add any other context about the problem here.
```

### 💡 Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion:

1. **Use a clear and descriptive title**
2. **Provide a detailed description of the suggested enhancement**
3. **Explain why this enhancement would be useful**
4. **List some examples of how the enhancement would be used**
5. **Specify if you're willing to implement the feature**

**Enhancement Template:**
```markdown
## Feature Description
A clear and concise description of the feature.

## Problem Statement
What problem does this feature solve?

## Proposed Solution
How should this feature work?

## Alternatives Considered
Alternative solutions you've considered.

## Additional Context
Mockups, examples, or additional context.
```

### 🔧 Contributing Code

1. **Fork** the repository
2. **Clone** your fork locally
3. **Create** a new branch for your feature/fix
4. **Make** your changes
5. **Test** your changes thoroughly
6. **Commit** your changes with clear messages
7. **Push** to your fork
8. **Create** a Pull Request

## 🛠️ Getting Started

### Prerequisites

- **Node.js** 16+ and npm
- **MongoDB** 5+
- **Git**
- **Code Editor** (VS Code recommended)

### Local Development Setup

```bash
# 1. Fork and clone the repository
git clone https://github.com/your-username/covid19-full-stack.git
cd covid19-full-stack

# 2. Set up upstream remote
git remote add upstream https://github.com/saifyxpro/covid19-full-stack.git

# 3. Install dependencies
cd server && npm install
cd ../client && npm install

# 4. Set up environment variables
cp server/.env.example server/.env
cp client/.env.example client/.env
# Edit the .env files with your configurations

# 5. Start MongoDB
mongod

# 6. Import sample data
mongoimport --uri "mongodb://localhost:27017/covid-19" --collection covid_statistics --file dummy_statistics.json

# 7. Start the application
# Terminal 1: Server
cd server && npm run dev

# Terminal 2: Client
cd client && npm start
```

### Development Tools

**Recommended VS Code Extensions:**
- ES7+ React/Redux/React-Native snippets
- Prettier - Code formatter
- ESLint
- GitLens
- Thunder Client (for API testing)
- MongoDB for VS Code

## 📝 Development Process

### Branching Strategy

We use a simplified Git flow:

- `main` - Production-ready code
- `develop` - Development branch (upcoming release)
- `feature/*` - Feature branches
- `bugfix/*` - Bug fix branches
- `hotfix/*` - Critical fixes

### Branch Naming Conventions

```bash
feature/add-user-authentication
feature/improve-map-performance
bugfix/fix-data-loading-issue
bugfix/resolve-memory-leak
hotfix/security-vulnerability-fix
```

### Commit Message Guidelines

We follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```bash
# Format
<type>[optional scope]: <description>

# Types
feat: A new feature
fix: A bug fix
docs: Documentation only changes
style: Code style changes (formatting, missing semicolons, etc)
refactor: Code changes that neither fix a bug nor add a feature
perf: Performance improvements
test: Adding missing tests or correcting existing tests
chore: Changes to build process or auxiliary tools

# Examples
feat(api): add user authentication endpoint
fix(map): resolve marker clustering issue
docs(readme): update installation instructions
style(client): fix code formatting issues
refactor(server): optimize database queries
perf(api): improve response time for statistics endpoint
test(auth): add unit tests for login functionality
chore(deps): update dependencies to latest versions
```

## 🔀 Pull Request Guidelines

### Before Submitting

- ✅ **Update documentation** if needed
- ✅ **Add tests** for new functionality
- ✅ **Ensure all tests pass** (`npm test`)
- ✅ **Follow coding standards**
- ✅ **Update CHANGELOG.md** if applicable
- ✅ **Check for merge conflicts**

### Pull Request Template

```markdown
## Description
Brief description of changes made.

## Type of Change
- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update

## Testing
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Manual testing completed

## Checklist
- [ ] My code follows the style guidelines
- [ ] I have performed a self-review
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have made corresponding changes to the documentation
- [ ] My changes generate no new warnings
- [ ] Any dependent changes have been merged and published

## Screenshots (if applicable)
Add screenshots to help explain your changes.

## Related Issues
Closes #123
Fixes #456
```

### Review Process

1. **Automated Checks**: GitHub Actions will run tests automatically
2. **Code Review**: At least one maintainer will review your PR
3. **Feedback**: Address any requested changes
4. **Merge**: Once approved, your PR will be merged

## 💻 Coding Standards

### JavaScript/Node.js Standards

```javascript
// Use ES6+ features
const fetchData = async () => {
  try {
    const response = await axios.get('/api/data');
    return response.data;
  } catch (error) {
    logger.error('Failed to fetch data:', error);
    throw error;
  }
};

// Use meaningful variable names
const userAuthenticationToken = generateToken(user);

// Add JSDoc comments for functions
/**
 * Validates user input for COVID-19 data
 * @param {Object} data - The data to validate
 * @param {string} data.country - Country name
 * @param {number} data.cases - Number of cases
 * @returns {boolean} True if valid, false otherwise
 */
function validateCovidData(data) {
  return data.country && typeof data.cases === 'number';
}
```

### React/JSX Standards

```jsx
// Use functional components with hooks
import React, { useState, useEffect } from 'react';

const CovidStatistics = ({ country }) => {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchCountryData(country)
      .then(setData)
      .finally(() => setLoading(false));
  }, [country]);

  if (loading) {
    return <LoadingSpinner />;
  }

  return (
    <div className="covid-statistics">
      <h2>{country} Statistics</h2>
      {data && (
        <div className="stats-grid">
          <StatCard label="Confirmed" value={data.confirmed} />
          <StatCard label="Deaths" value={data.deaths} />
          <StatCard label="Recovered" value={data.recovered} />
        </div>
      )}
    </div>
  );
};

export default CovidStatistics;
```

### CSS Standards

```css
/* Use BEM naming convention */
.covid-statistics {
  padding: 1rem;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.covid-statistics__header {
  margin-bottom: 1rem;
  font-size: 1.5rem;
  font-weight: 600;
}

.covid-statistics__grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1rem;
}

/* Use CSS custom properties for theming */
:root {
  --primary-color: #007bff;
  --secondary-color: #6c757d;
  --success-color: #28a745;
  --danger-color: #dc3545;
  --warning-color: #ffc107;
}
```

## 🧪 Testing Guidelines

### Testing Stack

- **Server**: Jest + Supertest
- **Client**: Jest + React Testing Library
- **E2E**: Cypress (planned)

### Writing Tests

**Server Tests:**
```javascript
// server/tests/api.test.js
const request = require('supertest');
const app = require('../app');

describe('COVID-19 API', () => {
  describe('GET /api/statistics', () => {
    it('should return COVID-19 statistics', async () => {
      const response = await request(app)
        .get('/api/statistics')
        .expect(200);

      expect(response.body).toHaveProperty('total_confirmed');
      expect(response.body).toHaveProperty('country_statistics');
      expect(Array.isArray(response.body.country_statistics)).toBe(true);
    });
  });
});
```

**Client Tests:**
```javascript
// client/src/components/CovidStatistics.test.js
import React from 'react';
import { render, screen, waitFor } from '@testing-library/react';
import { Provider } from 'react-redux';
import { store } from '../store';
import CovidStatistics from './CovidStatistics';

const MockedComponent = ({ country }) => (
  <Provider store={store}>
    <CovidStatistics country={country} />
  </Provider>
);

describe('CovidStatistics', () => {
  it('renders loading state initially', () => {
    render(<MockedComponent country="US" />);
    expect(screen.getByText(/loading/i)).toBeInTheDocument();
  });

  it('displays statistics after loading', async () => {
    render(<MockedComponent country="US" />);
    
    await waitFor(() => {
      expect(screen.getByText(/confirmed/i)).toBeInTheDocument();
    });
  });
});
```

### Test Coverage

- Aim for **80%+ code coverage**
- Focus on critical paths and business logic
- Write both unit and integration tests
- Include error scenarios

## 📚 Documentation

### Code Documentation

- **JSDoc comments** for all functions and classes
- **README updates** for new features
- **API documentation** for new endpoints
- **Inline comments** for complex logic

### Documentation Standards

```javascript
/**
 * Fetches COVID-19 statistics for a specific country
 * @async
 * @function fetchCountryStatistics
 * @param {string} countryCode - ISO country code (e.g., 'US', 'IN')
 * @param {Object} options - Fetch options
 * @param {boolean} options.includeStates - Include state-level data
 * @returns {Promise<Object>} COVID-19 statistics object
 * @throws {Error} Throws error if country not found or API fails
 * @example
 * const stats = await fetchCountryStatistics('US', { includeStates: true });
 * console.log(stats.confirmed); // Total confirmed cases
 */
async function fetchCountryStatistics(countryCode, options = {}) {
  // Implementation
}
```

## 🏷️ Issue Labels

We use the following labels to categorize issues:

### Type Labels
- `bug` - Something isn't working
- `feature` - New feature or request
- `enhancement` - Improvement to existing feature
- `documentation` - Documentation improvements
- `question` - Further information is requested

### Priority Labels
- `priority-critical` - Critical issues that break functionality
- `priority-high` - High priority issues
- `priority-medium` - Medium priority issues
- `priority-low` - Low priority issues

### Status Labels
- `status-awaiting-triage` - Needs initial review
- `status-in-progress` - Currently being worked on
- `status-blocked` - Blocked by external dependency
- `status-ready-for-review` - Ready for code review

### Area Labels
- `area-frontend` - Frontend/React related
- `area-backend` - Backend/Node.js related
- `area-database` - Database related
- `area-api` - API related
- `area-security` - Security related
- `area-performance` - Performance related

## 🌍 Community

### Communication Channels

- **GitHub Issues**: Bug reports, feature requests
- **GitHub Discussions**: General discussions, Q&A
- **Twitter**: [@saifyxpro](https://twitter.com/saifyxpro) - Updates and announcements

### Getting Help

1. **Search existing issues** first
2. **Check the documentation** and README
3. **Ask questions** in GitHub Discussions
4. **Create an issue** if you find a bug

### Recognition

Contributors are recognized in:
- **README.md** contributors section
- **CHANGELOG.md** release notes
- **GitHub contributors** page
- **Special mentions** in release announcements

## 📊 Project Metrics

We track the following metrics:
- Code coverage percentage
- Build success rate
- Issue resolution time
- Pull request review time
- Community engagement

## 🎯 Contribution Goals

**For New Contributors:**
- Fix documentation typos
- Add unit tests
- Implement small features
- Improve error messages

**For Experienced Contributors:**
- Performance optimizations
- New major features
- Security improvements
- Architecture enhancements

## ❓ Questions?

Don't hesitate to ask! We're here to help:

- **GitHub Issues**: Technical questions
- **Email**: [saifyxpro@gmail.com](mailto:saifyxpro@gmail.com)
- **Twitter**: [@saifyxpro](https://twitter.com/saifyxpro)

---

## 🙏 Thank You!

Thank you for taking the time to contribute! Every contribution, no matter how small, makes a difference. 

**Happy coding!** 🚀

---

<div align="center">

**Made with ❤️ by [Saify](https://github.com/saifyxpro) and the community**

</div>
