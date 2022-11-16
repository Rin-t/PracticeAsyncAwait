//
//  ViewController.swift
//  practiceAsyncAwait
//
//  Created by Rin on 2022/11/16.
//

import UIKit

class ViewController: UIViewController {

    let serverTaskWithoutAsyncAwait = ServerTaskWithoutAsyncAwait()
    let serverTaskWithAsyncAwait = ServerTaskWithAsyncAwait()

    @IBAction private func tappedWithAsyncAwaitButton(_ sender: UIButton) {
        print("async/await")
        Task {
            let total = await serverTaskWithAsyncAwait.executeBothTask()
            print("total: \(total)")
        }
    }

    @IBAction private func tappedWithoutAsyncAwaitButton(_ sender: UIButton) {
        print("closure")
        serverTaskWithoutAsyncAwait.executeBothTask { total in
            print("total: \(total)")
        }
    }
}


class ServerTaskWithoutAsyncAwait {

    private func task1(completion: @escaping (Int) -> Void) {
        sleep(1)
        print("タスク1完了")
        completion(2)
    }

    private func task2(completion: @escaping (Int) -> Void) {
        sleep(2)
        print("タスク2完了")
        completion(3)
    }

    func executeBothTask(completion: @escaping (Int) -> Void) {
        task1 { [weak self] num1 in
            self?.task2 { num2 in
                completion(num1 + num2)
            }
        }
    }
}

class ServerTaskWithAsyncAwait {

    private func task1() async -> Int {
        sleep(1)
        print("タスク1完了")
        return 3
    }

    private func task2() async -> Int {
        sleep(2)
        print("タスク2完了")
        return 1
    }

    func executeBothTask() async -> Int {
        let num1 = await task1()
        let num2 = await task2()
        return num1 + num2
    }
}
