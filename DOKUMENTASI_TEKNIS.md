# 📚 DOKUMENTASI TEKNIS APLIKASI RESPONSI

## Struktur Proyek

```
lib/
├── main.dart                          # Entry point & route config
├── models/
│   └── news_model.dart               # News & Release data models
└── screens/
    ├── login_screen.dart             # Authentication (Soal 1)
    ├── home_screen.dart              # Article list (Soal 2)
    ├── detail_screen.dart            # Article detail (Soal 3)
    ├── favorite_screen.dart          # Favorites list (Soal 4)
    └── main_navigation.dart          # Bottom nav wrapper
```

## File Descriptions

### 1. **lib/main.dart**
Entry point aplikasi dengan route configuration.

**Key Components:**
- `MyApp`: Root widget
- Route mapping: `/` (Login), `/home` (MainNavigation)
- Theme: Material Design 3 dengan primary blue color

**Important Code:**
```dart
initialRoute: '/',
routes: {
  '/': (context) => const LoginPage(),
  '/home': (context) => const MainNavigation(),
}
```

### 2. **lib/models/news_model.dart**
Data models untuk artikel berita.

**News Class Fields:**
- `int id`: Unique identifier
- `String title`: Article title
- `List<String> authors`: Author names
- `String url`: Article URL
- `String imageUrl`: Image URL (image_url from API)
- `String newsSite`: News source (news_site from API)
- `String summary`: Article summary
- `String publishedAt`: Publication date (published_at from API)
- `String updatedAt`: Update date (updated_at from API)
- `bool featured`: Is featured flag
- `List<dynamic> launches`: Space launches
- `List<dynamic> events`: Related events

**Key Methods:**
- `News.fromJson()`: Parse dari API response
- `toJson()`: Convert ke JSON untuk storage

### 3. **lib/screens/login_screen.dart**
Authentication screen (Soal 1).

**Features:**
- Form dengan GlobalKey validation
- Username & password text fields
- Password visibility toggle button
- Validasi field (tidak boleh kosong)
- Hardcoded credentials: `Raya` / `137`
- Error feedback dengan SnackBar
- Navigation ke MainNavigation setelah login

**Key Widgets:**
- `TextFormField` dengan validator
- `ElevatedButton` untuk login action
- `IconButton` untuk password visibility toggle

### 4. **lib/screens/home_screen.dart**
Main article list screen (Soal 2).

**Features:**
- FutureBuilder untuk async API call
- ListView untuk article list
- Favorit toggle dengan visual feedback
- Image loading error handling
- Loading indicator
- Navigasi ke detail screen
- Refresh favorit status setelah kembali

**Key Data Management:**
```dart
Set<String> _favoriteIds = {};  // Track favorit status
Future<List<News>> fetchNews()  // API call
Future<void> _toggleFavorite(News news)  // Add/remove favorit
```

**API Integration:**
```dart
final response = await http.get(
  Uri.parse('https://api.spaceflightnewsapi.net/v4/articles/'),
);
final Map<String, dynamic> data = json.decode(response.body);
final List<dynamic> newsJson = data['results'] ?? [];
```

### 5. **lib/screens/detail_screen.dart**
Article detail display screen (Soal 3).

**Features:**
- Large article image dengan rounded corners
- Article title dan metadata
- Summary content
- Favorit toggle di AppBar
- Read full article button
- ScrollView untuk long content
- Proper error handling

**UI Components:**
- `ClipRRect` untuk image styling
- `Container` untuk source/date info box
- `ElevatedButton.icon` untuk read more action
- `ErrorBuilder` untuk image loading failures

### 6. **lib/screens/favorite_screen.dart**
Favorites list display (Soal 4).

**Features:**
- Display favorit articles dari SharedPreferences
- Swipe-to-delete dengan `Dismissible` widget
- Hapus dari favorit
- Navigasi ke detail
- Refresh setelah update
- Empty state message

**Key Functionality:**
```dart
Future<void> _loadFavorites()   // Load dari storage
Future<void> _removeFavorite(int index)  // Delete favorite
Dismissible(
  direction: DismissDirection.horizontal,
  onDismissed: (direction) => _removeFavorite(index),
)
```

### 7. **lib/screens/main_navigation.dart**
Bottom navigation wrapper (NEW).

**Features:**
- BottomNavigationBar dengan 2 tabs
- AppBar dengan logout button
- Screen switching dengan setState
- Logout confirmation dialog
- Route reset setelah logout

**Navigation Routes:**
- Tab 0: HomeScreen (icons.home)
- Tab 1: FavoriteScreen (icons.favorite)

**Logout Implementation:**
```dart
Navigator.pushNamedAndRemoveUntil(
  context,
  '/',
  (route) => false,  // Clear all routes
);
```

---

## Data Flow & Architecture

### API Integration Flow
```
fetchNews()
  ↓
HTTP GET to Space Flight News API
  ↓
Parse response (data['results'])
  ↓
Map to News objects
  ↓
Return List<News>
```

### Favorite Management Flow
```
User taps favorite icon
  ↓
_toggleFavorite() called
  ↓
Check if already in favorites
  ↓
If no: Add to SharedPreferences & update _favoriteIds
If yes: Remove dari SharedPreferences & update _favoriteIds
  ↓
setState() untuk rebuild UI
  ↓
Show SnackBar notification
```

### Authentication Flow
```
User inputs credentials
  ↓
Form validation
  ↓
Compare dengan hardcoded (Raya / 137)
  ↓
If match: Navigate to MainNavigation
If not: Show error SnackBar
```

### Navigation Flow
```
LoginPage
  ↓ (after login)
MainNavigation (with BottomNavigationBar)
  ├─ HomeScreen (Tab 0)
  │  └─ DetailScreen (on item tap)
  └─ FavoriteScreen (Tab 1)
     └─ DetailScreen (on item tap)
```

---

## State Management Strategy

### Local State (StatefulWidget)
```dart
// HomeScreen
Set<String> _favoriteIds = {};  // Track which articles are favorited
late Future<List<News>> _newsList;  // Cache API future

// MainNavigation
int _selectedIndex = 0;  // Current tab index

// DetailScreen & FavoriteScreen
bool isFavorite = false;  // Current article status
List<News> _favorites = [];  // List of favorited articles
```

### Persistent State (SharedPreferences)
```
Key: 'favorites'
Value: List<String> (array of JSON-encoded News objects)
```

---

## Error Handling Strategy

### API Errors
```dart
if (response.statusCode == 200) {
  // Success
} else {
  throw Exception('Failed to load articles');
}
```

### Image Loading Errors
```dart
Image.network(
  imageUrl,
  errorBuilder: (context, error, stackTrace) =>
    Icon(Icons.error),  // Fallback UI
)
```

### Mount Check
```dart
if (mounted) {
  ScaffoldMessenger.of(context).showSnackBar(...);
}
```

---

## SharedPreferences Data Format

### Storage Format
```dart
// Key: 'favorites'
// Value: List<String>
[
  "{\"id\":1,\"title\":\"...\",\"news_site\":\"...\", ...}",
  "{\"id\":2,\"title\":\"...\",\"news_site\":\"...\", ...}",
  ...
]
```

### Save Operation
```dart
await prefs.setStringList('favorites', savedFavorites);
```

### Load Operation
```dart
List<String> savedFavorites = prefs.getStringList('favorites') ?? [];
List<News> favorites = savedFavorites
    .map((item) => News.fromJson(json.decode(item)))
    .toList();
```

---

## UI/UX Design Patterns

### Colors
- Primary: Blue (0xFF7E90FF)
- Accent: Red (Colors.red)
- Background: White
- Text: Black/Grey

### Typography
- Titles: 24-28px, FontWeight.bold
- Subtitles: 14-18px, Colors.grey
- Labels: 12-16px, FontWeight.w500

### Spacing
- Card margin: 10px horizontal, 5px vertical
- Content padding: 16px all around
- SizedBox: 10-30px between elements

### Widgets Used
- `Scaffold`: Page structure
- `AppBar`: Top navigation
- `BottomNavigationBar`: Tab navigation
- `ListView/FutureBuilder`: Content display
- `ListTile`: List items
- `Card`: Item containers
- `TextField/TextFormField`: Input
- `Dismissible`: Swipe actions
- `Dialog`: Confirmations
- `SnackBar`: Notifications

---

## Performance Considerations

### Image Loading
- Network images cached by default
- Error handling prevents crashes
- Proper sizing prevents memory issues

### API Calls
- Single fetchNews() call on init
- No continuous polling
- Error state properly handled

### List Performance
- ListView.builder for efficient rendering
- Only visible items rendered
- Proper disposal of controllers

### Storage Operations
- Async SharedPreferences operations
- No blocking operations
- Proper error handling

---

## Testing Checklist

- [x] Login dengan credentials benar
- [x] Login dengan credentials salah (error message)
- [x] Load artikel dari API
- [x] Display article list dengan image
- [x] Toggle favorit (icon change & color)
- [x] Navigate ke detail screen
- [x] Back dari detail screen (favorit status sync)
- [x] View favorit screen
- [x] Swipe to delete dari favorit
- [x] Logout dengan confirmation
- [x] Switch tab navigation
- [x] Image loading error handling
- [x] Empty favorit message
- [x] SnackBar notifications

---

## Future Improvements

### Possible Enhancements
1. Add URL launcher untuk "Read More" button
2. Implement image caching dengan cached_network_image
3. Add filtering/search functionality
4. Implement pagination untuk article list
5. Add dark mode support
6. Add animations untuk screen transitions
7. Implement pull-to-refresh
8. Add more detailed error messages

### Performance Optimizations
1. Lazy load images
2. Implement pagination
3. Add local caching untuk API results
4. Optimize list rendering

---

**Dokumentasi ini membantu untuk memahami struktur, architecture, dan implementasi aplikasi Responsi.**
