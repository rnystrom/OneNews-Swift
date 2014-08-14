// Playground - noun: a place where people can play

import Foundation

func flatten<T> (array: Array<[T]>) -> [T] {
    return array.reduce([T](), +)
}

let a1 = [1, 2, 3, 4, 5]
let a2 = [6, 7, 8, 9, 10]
let arr = [a1, a2]
let flat = flatten(arr)