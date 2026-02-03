# LibApartado Frontend

React frontend for the LibApartado space reservation system.

## Tech Stack

- **React 18** - UI library
- **Vite** - Build tool and dev server
- **React Router v6** - Client-side routing
- **Axios** - HTTP client with interceptors
- **date-fns** - Date manipulation
- **CSS Modules** - Component-scoped styling

## Getting Started

### Prerequisites

- Node.js 18+ and npm
- Backend API running on `http://localhost:8000`

### Installation

```bash
cd frontend
npm install
```

### Development

```bash
npm run dev
```

The app will be available at `http://localhost:3000`

### Build for Production

```bash
npm run build
```

### Preview Production Build

```bash
npm run preview
```

## Project Structure

```
src/
├── components/         # Reusable UI components
│   ├── Layout/        # Main layout with navigation
│   ├── ProtectedRoute/# Auth route wrapper
│   └── ...
├── contexts/          # React contexts (Auth, etc.)
├── pages/             # Page components
│   ├── Login/
│   ├── Dashboard/
│   ├── Spaces/
│   ├── MyReservations/
│   ├── CreateReservation/
│   └── Admin/
├── services/          # API client and services
├── utils/             # Utility functions
├── App.jsx           # Root component with routes
├── main.jsx          # Entry point
└── index.css         # Global styles
```

## Features

### User Features
- Login with JWT authentication
- View available spaces and their availability
- Create reservations with overlap validation
- View and cancel own reservations
- Dashboard with upcoming reservations

### Admin Features
- Manage users (CRUD)
- Manage spaces (CRUD)
- Approve/reject reservations
- View all reservations with full details
- Edit existing reservations

## Environment Variables

The Vite proxy is configured to forward `/api` requests to `http://localhost:8000`.

To change the backend URL, edit `vite.config.js`:

```javascript
server: {
  proxy: {
    '/api': {
      target: 'http://your-backend-url',
      changeOrigin: true,
    }
  }
}
```

## API Integration

All API calls go through the centralized `apiClient` in `src/services/api.js` which handles:
- JWT token attachment
- Automatic token refresh on 401 errors
- Request/response interceptors
- Error handling

## Authentication Flow

1. User logs in via `/login`
2. JWT tokens stored in localStorage
3. `AuthContext` provides user state globally
4. `ProtectedRoute` component guards authenticated routes
5. Axios interceptor auto-refreshes expired tokens
