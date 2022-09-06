#pragma once

#include <concepts>
#include <format>
#include <optional>

#include "Vec2.h"

class Aabb {
  public:
	Vec2 p0{0.0, 0.0};
	Vec2 p1{0.0, 0.0};
};

template <typename T>
concept HasAabb = requires(T v) {
	{ v.aabb() } -> std::same_as<Aabb>;
};

std::optional<float> timeToOverlap(float a0, float a1, float b0, float b1,
								   float va, float vb) {
	if (a0 < b0 and a1 < b0 and va != vb) {
		return (a1 - b0) / (vb - va);
	} else if (b0 < a0 and b1 < a0 and va != vb) {
		return (b1 - a0) / (va - vb);
	} else if (a0 < b0 and abs(b0 - a0) <= (a1 - a0)) {
		return 0.0;
	} else if (abs(b0 - a0) <= b1 - b0) {
		return 0.0;
	} else {
		return std::nullopt;
	}
}

std::optional<float> timeToDisjoint(float a0, float a1, float b0, float b1,
									float va, float vb) {
	//  |a0------|a1
	//  |-----------t----------|
	//                |b0------|b1 <-v
	//      ~ or ~
	//       |a0------|a1
	//       |-t-|
	//  |b0------|b1 <-v
	//      ~ or ~
	//  |a0------|a1
	//      |-t--|
	//      |b0------|b1 <-v
	//      ~ or ~
	//     |a0------|a1
	//     |-----t-----|
	//  |b0------------|b1 <-v
	//      ~ or ~
	// |a0------------|a1
	// |------t----|
	//     |b0-----|b1 <-v
	const auto v = vb - va;
	if (v < 0.0) {
		return (a0 - b1) / v;
	} else if (v > 0.0) {
		return (a1 - b0) / v;
	} else {
		return std::nullopt;
	}
}

template <HasAabb T, HasAabb U>
std::optional<float> timeToOverlap(T a, U b, Vec2 va, Vec2 vb) {
	const auto aabbA = a.aabb();
	const auto aabbB = b.aabb();
	const auto timeToOverlapX = timeToOverlap(
		aabbA.p0.x, aabbA.p1.x, aabbB.p0.x, aabbB.p1.x, va.x, vb.x);
	const auto timeToOverlapY = timeToOverlap(
		aabbA.p0.y, aabbA.p1.y, aabbB.p0.y, aabbB.p1.y, va.y, vb.y);

	if (timeToOverlapX and timeToOverlapY) {
		return std::max(timeToOverlapX.value(), timeToOverlapY.value());
	} else {
		return std::nullopt;
	}
}

// template <HasAabb T, HasAabb U>
// std::optional<float> timeToDisjoint(T a, U b, Vec2 va, Vec2 vb) {
// 	const auto aabbA = a.aabb();
// 	const auto aabbB = b.aabb();
// 	const auto timeToDisjointX = timeToOverlap(
// 		aabbA.p0.x, aabbA.p1.x, aabbB.p0.x, aabbB.p1.x, va.x, vb.x);
// 	const auto timeToDisjointY = timeToOverlap(
// 		aabbA.p0.y, aabbA.p1.y, aabbB.p0.y, aabbB.p1.y, va.y, vb.y);

//   if timeToDisjointX.isSome() and timeToDisjointY.isSome():
//     return some(min(timeToDisjointX.get(), timeToDisjointY.get()))
//   elif timeToDisjointX.isSome():
//     return timeToDisjointX
//   elif timeToDisjointY.isSome():
//     return timeToDisjointY
//   else:
//     return none(float)
// }

// func timeToCollision*[T, U: Aabb](a: T; b: U; va, vb: Vec2): Option[float] =
//   let overlapTime = timeToOverlap(a, b, va, vb)
//   let disjointTime = timeToDisjoint(a, b, va, vb)

//   if overlapTime.isSome() and disjointTime.isSome():
//     if overlapTime.get() < disjointTime.get():
//       return overlapTime
//     else:
//       return none(float)
//   elif overlapTime.isSome():
//     return overlapTime
//   else:
//     return none(float)

// func overlap*[T, U: Aabb](a: T; b: U): Vec2 =
//   let dx = max(0.0, min(a.p1.x, b.p1.x) - max(a.p0.x, b.p0.x))
//   let dy = max(0.0, min(a.p1.y, b.p1.y) - max(a.p0.y, b.p0.y))
//   return Vec2(x: dx, y: dy)