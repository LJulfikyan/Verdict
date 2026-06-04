# Firestore Index Report

## Scope

This report covers the Firestore queries currently present in the codebase for:

- Feed
- Saved Cases
- Notifications
- Profile
- Future rate limiting queries already present in code

It only includes composite indexes required by actual queries found in the repository.

## Generated Indexes

### 1. Feed base query

- **Index**
  - `cases`: `status ASC, hotScore DESC`
- **Exact file**
  - `lib/data/datasources/firestore_datasource.dart:26`
- **Exact query**
  - `casesCollection.where('status', isEqualTo: 'active').orderBy('hotScore', descending: true)`
- **Why Firestore requires it**
  - This query combines an equality filter on `status` with an `orderBy` on `hotScore`. Firestore requires a composite index when filtering on one field and ordering by another field in the same collection query.

### 2. Feed query with category filter

- **Index**
  - `cases`: `status ASC, category ASC, hotScore DESC`
- **Exact file**
  - `lib/data/datasources/firestore_datasource.dart:26`
- **Exact query**
  - `casesCollection.where('status', isEqualTo: 'active').where('category', isEqualTo: category).orderBy('hotScore', descending: true)`
- **Why Firestore requires it**
  - This query combines equality filters on `status` and `category` with ordering by `hotScore`. Firestore requires a composite index spanning the filter fields and the ordered field.

### 3. Feed query with relationship filter

- **Index**
  - `cases`: `status ASC, relationshipType ASC, hotScore DESC`
- **Exact file**
  - `lib/data/datasources/firestore_datasource.dart:26`
- **Exact query**
  - `casesCollection.where('status', isEqualTo: 'active').where('relationshipType', isEqualTo: relationshipType).orderBy('hotScore', descending: true)`
- **Why Firestore requires it**
  - This query combines equality filters on `status` and `relationshipType` with ordering by `hotScore`. Firestore requires a composite index spanning the filter fields and the ordered field.

### 4. Feed query with category + relationship filters

- **Index**
  - `cases`: `status ASC, category ASC, relationshipType ASC, hotScore DESC`
- **Exact file**
  - `lib/data/datasources/firestore_datasource.dart:26`
- **Exact query**
  - `casesCollection.where('status', isEqualTo: 'active').where('category', isEqualTo: category).where('relationshipType', isEqualTo: relationshipType).orderBy('hotScore', descending: true)`
- **Why Firestore requires it**
  - This is the combined branch of the current feed query builder when both optional filters are supplied. Firestore requires a composite index across all equality-filter fields plus the ordered field.

### 5. Future / Not Currently Used at runtime: rate limit audit query

- **Index**
  - `audit_logs`: `action ASC, userId ASC, createdAt ASC`
- **Exact file**
  - `functions/index.js:610`
- **Exact query**
  - `db.collection(AUDIT_LOGS_COLLECTION).where('action', '==', \`rate_limit:${action}\`).where('userId', '==', userId).where('createdAt', '>=', windowStart).get()`
- **Why Firestore requires it**
  - This query combines equality filters on `action` and `userId` with a range filter on `createdAt`. Firestore requires a composite index covering the equality filters followed by the range field.
- **Future / Not Currently Used**
  - The query exists in code today, but runtime enforcement is disabled because all entries in `RATE_LIMITS` currently have `enabled: false` in `functions/index.js:24`.

## Queries That Do Not Need Composite Indexes

### Saved Cases

- **Exact file**
  - `lib/data/datasources/firestore_datasource.dart:101`
- **Exact query**
  - `savedCasesCollection(userId).orderBy('savedAt', descending: true)`
- **Composite index required**
  - No
- **Reason**
  - This is a single-field `orderBy` on a user subcollection with no additional filter. Firestore handles this with built-in single-field indexing.

### Notifications

- **Exact file**
  - `lib/data/datasources/firestore_datasource.dart:173`
  - `lib/data/datasources/notification_datasource.dart:13`
- **Exact query**
  - `notificationsCollection(userId).orderBy('createdAt', descending: true)`
- **Composite index required**
  - No
- **Reason**
  - This is a single-field `orderBy` on a user subcollection with no additional filter. Firestore handles this with built-in single-field indexing.

### Profile authored cases fallback

- **Exact file**
  - `lib/data/datasources/firestore_datasource.dart:18`
- **Exact query**
  - `casesCollection.where('authorId', isEqualTo: userId)`
- **Composite index required**
  - No
- **Reason**
  - This is a single equality filter with no explicit ordering. Firestore handles this with built-in single-field indexing.

### Case-by-ID and case watch queries

- **Exact file**
  - `lib/data/datasources/firestore_datasource.dart:43`
  - `lib/data/datasources/firestore_datasource.dart:47`
- **Exact queries**
  - `casesCollection.doc(caseId).get()`
  - `casesCollection.doc(caseId).snapshots()`
- **Composite index required**
  - No
- **Reason**
  - Direct document lookups never require composite indexes.

### Batch fetch saved case IDs by `documentId`

- **Exact file**
  - `lib/data/datasources/firestore_datasource.dart:117`
- **Exact query**
  - `casesCollection.where(FieldPath.documentId, whereIn: [...]).get()`
- **Composite index required**
  - No
- **Reason**
  - `documentId whereIn` on a single field does not require a composite index.

## Validation

Every generated composite index corresponds to at least one existing query in the codebase:

- 4 indexes map to the live feed query builder in `lib/data/datasources/firestore_datasource.dart:26`
- 1 index maps to the existing rate-limit query in `functions/index.js:610`

No unused speculative composite indexes were included.
