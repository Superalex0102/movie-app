//
//  MediaItemStore.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 05. 17..
//

import RealmSwift
import Combine

protocol MediaItemStoreProtocol {
    var mediaItems: AnyPublisher<[Movie], MovieError> { get }
    
    func saveMediaItems(_ items: [Movie])
    func deleteMediaItem(withId id: Int)
    func deleteAll()
    
    func isMediaItemStored(withId id: Int) -> Bool
}

class MediaItemStore: MediaItemStoreProtocol {
    private let realm: Realm
    private var notificationToken: NotificationToken?
    private let subject = CurrentValueSubject<[Movie], MovieError>([])
    
    var mediaItems: AnyPublisher<[Movie], MovieError> {
        subject.eraseToAnyPublisher()
    }
    
    init() {
        guard let realm = try? Realm() else {
            fatalError("Failed to initialize Realm")
        }
        
        self.realm = realm
        //Elindít egy megfigyelést (observeMediaItems()), amely figyeli a MediaItemEntity változásait.
        observeMediaItems()
    }

    private func observeMediaItems() {
        let results = realm.objects(MediaItemEntity.self)
        //Bármilyen módosítás történik MediaItemEntity-n (pl. mentés, törlés), a subject-et frissíti Combine-on keresztül. Így a feliratkozók (pl. ViewModel) automatikusan értesülnek az adatok változásáról.
        notificationToken = results.observe { [weak self] changes in
            switch changes {
            case .initial(let items),
                 .update(let items, _, _, _):
                self?.subject.send(items.map { $0.toDomain })
            case .error(let error):
                print("Realm observe error: \(error)")
            }
        }
    }

    func saveMediaItems(_ items: [Movie]) {
        let entities = items.map { item in
            MediaItemEntity(from: item)
        }
        // A domain modellből (MediaItem) adatbázis entitást készít (MediaItemEntity) Mentés történik, frissítésre is képes (.modified).
        try? realm.write {
            realm.add(entities, update: .modified)
        }
    }

    func deleteMediaItem(withId id: Int) {
        if let object = realm.object(ofType: MediaItemEntity.self, forPrimaryKey: id) {
            try? realm.write {
                realm.delete(object)
            }
        }
    }

    func deleteAll() {
        let all = realm.objects(MediaItemEntity.self)
        try? realm.write {
            realm.delete(all)
        }
    }

    func isMediaItemStored(withId id: Int) -> Bool {
        realm.object(ofType: MediaItemEntity.self, forPrimaryKey: id) != nil
    }

    deinit {
        //Fontos memória-kezelés: leiratkozik a Realm megfigyelésről.
        notificationToken?.invalidate()
    }
}
