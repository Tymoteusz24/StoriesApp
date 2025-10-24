# StoriesApp - Instagram Stories Clone

SwiftUI-based iOS application implementing Instagram-like Stories with infinite scrolling, persistence, and smooth animations.

> **Note**: This project reuses my personal modular architecture structure (SPM packages, networking layer, storage wrappers) that I've developed for scalable iOS apps.

---

## ✅ Features Delivered

### Story List
- ✅ Infinite pagination (stories repeat with unique IDs)
- ✅ Seen/unseen visual indicators
- ✅ Shimmer loading effects
- ✅ Error handling with retry

### Story Viewer
- ✅ Instagram-like gestures (tap left/right, swipe down, double-tap to like, long-press to pause)
- ✅ Auto-advance to next story
- ✅ Progress bars with smooth animations
- ✅ Like/Unlike with heart animation
- ✅ Full-screen immersive experience

### Persistence
- ✅ SwiftData for local storage
- ✅ Seen/unseen states persist across sessions
- ✅ Like/unlike states persist across sessions

---

## 🏗 Architecture Overview

**Modular Clean Architecture with MVVM**

```
StoriesApp/
├── Foundation/              # Reusable frameworks (my personal structure)
│   ├── Domain/             # Business logic + Data layer
│   ├── Networking/         # API client abstraction
│   ├── Storage/            # SwiftData wrapper
│   ├── Router/             # Navigation system
│   └── SystemDesign/       # UI components
└── Features/
    └── Stories/            # Feature-specific code
        ├── Coordinator/    # Navigation
        └── Presentation/   # Views & ViewModels
```

**Benefits**: Fast compilation, clear boundaries, easy testing, reusable across projects.

---

## 🎯 Key Technical Decisions

### 1. **Navigation Strategy: NavigationStack (Not TabView)**
**Problem**: TabView loads ALL stories into memory → not scalable for 1000+ stories.

**Solution**: NavigationStack with ID-based navigation
- Each story is a separate navigation item
- Only loads current story into memory
- Scalable for infinite stories

```swift
router.navigate(to: .storyViewer(storyId: story.id))
```

### 2. **Persistence: SwiftData (Not Core Data)**
**Why**: Modern, less boilerplate, SwiftUI-native
- Stores only interactions (seen/liked states), not full stories
- Automatic sync with UI via `@Query`

### 3. **Concurrency: Actor + async/await (Not @escaping closures)**
**Why**: Thread-safe, modern Swift
- `StoriesService` is an `actor` → thread-safe state
- ViewModels use `@MainActor` → safe UI updates

### 4. **Image Loading: SDWebImageSwiftUI**
**Why**: Only external dependency
- AsyncImage lacks caching → poor performance
- SDWebImage: disk/memory cache, placeholders, smooth scrolling

### 5. **Auto-Advance: Task-based Timer (Not Timer class)**
**Why**: Better Swift Concurrency integration
```swift
Task { @MainActor in
    for _ in 0..<totalSteps {
        try? await Task.sleep(for: .milliseconds(10))
        progress += step
    }
    onStoryComplete?() // Auto-advance
}
```

### 6. **Mock Pagination: Client-side ID Multiplication**
**Why**: Simple, demonstrates infinite scrolling concept
```swift
let newId = baseStory.id + (page * baseCount)
// Story 1 becomes: 1, 11, 21, 31... (infinite)
```
Real implementation would use cursor/offset-based API pagination.

---

## 📊 Data Source

- **Mock JSON**: 10 base stories in `sample_stories.json`
- **Images**: 
  - Avatars: `i.pravatar.cc` (free API)
  - Stories: `picsum.photos` (free API)
- **Pagination**: Infinite via ID multiplication

---

## 🚀 Performance Highlights

1. **Lazy rendering** (`LazyVStack`) → only visible rows rendered
2. **Image caching** (SDWebImage) → smooth scrolling
3. **Single story loading** (NavigationStack) → memory-efficient
4. **Actor isolation** → thread-safe without locks
5. **Shimmer skeletons** → perceived performance

---

## 🎨 UX Polish

- **Shimmer loading** (Facebook-style)
- **Smooth animations** (progress, like, transitions)
- **Error states** with retry button
- **Instagram-accurate gestures**:
  - Tap zones (left 1/3, right 2/3)
  - Double-tap to like
  - Long-press to pause
  - Swipe down to dismiss

---

## 📝 Known Limitations

1. **Images only** (no video) - time constraint
2. **Mock pagination** (not real API)
3. **Single story per user** (no user grouping)
4. **No story expiration** (24h timeout not implemented)

All easily addressable with more time or real backend.

---

## 🏃‍♂️ Running the App

**Requirements**: Xcode 15+, iOS 17+

```bash
1. Open StoriesApp.xcodeproj
2. Wait for SPM to resolve
3. Build & Run (⌘R)
```

**First launch**: Shimmer → 20 stories load → Scroll for more → Tap to view

---

## ⏱ Development Time

**~4 hours total**
- Architecture setup (reused): 30 min
- Domain layer: 45 min  
- Story list UI: 60 min
- Story viewer: 90 min
- Polish & fixes: 15 min

---

## 🔑 Summary

| What | Why |
|------|-----|
| **SwiftUI** | Modern, less code |
| **SPM Modules** | Fast builds, reusability |
| **NavigationStack** | Memory-efficient (vs TabView) |
| **SwiftData** | Modern (vs Core Data) |
| **Actor** | Thread-safe (vs locks) |
| **SDWebImage** | Caching (vs AsyncImage) |
| **Task Timer** | Modern (vs Timer class) |

---

**Developer**: Tymoteusz Pasieka  
**Project**: BeReal Technical Assessment  
**Date**: October 2025

