
#include "Aabb.h"
#include "Vec2.h"

class Mover {
  public:
	Aabb m_aabb{};

	Mover(Aabb aabb) { this->m_aabb = aabb; }

	Aabb aabb() { return this->m_aabb; }
};

void testMover() {
	const Mover m{Aabb{{0.0, 0.0}, {1.0, 1.0}}};
	const Mover n{Aabb{{5.0, 0.0}, {6.0, 1.0}}};
	const auto t = timeToOverlap(m, n, Vec2{0.0, 0.0}, Vec2{0.0, 0.0});
	if (t) {
		printf("Time to Overlap %f\n", t.value());
	} else {
		printf("Won't Overlap\n");
	}
}