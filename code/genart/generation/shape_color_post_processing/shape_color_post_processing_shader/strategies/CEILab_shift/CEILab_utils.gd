class_name CEILabUtils extends Node


static func rgb2xyz(c: Vector3) -> Vector3:
	var tmp = Vector3()
	tmp.x = pow((c.x + 0.055) / 1.055, 2.4) if c.x > 0.04045 else c.x / 12.92
	tmp.y = pow((c.y + 0.055) / 1.055, 2.4) if c.y > 0.04045 else c.y / 12.92
	tmp.z = pow((c.z + 0.055) / 1.055, 2.4) if c.z > 0.04045 else c.z / 12.92

	var mat = [
		Vector3(0.4124, 0.3576, 0.1805),
		Vector3(0.2126, 0.7152, 0.0722),
		Vector3(0.0193, 0.1192, 0.9505)
	]

	return 100.0 * Vector3(
		tmp.dot(mat[0]),
		tmp.dot(mat[1]),
		tmp.dot(mat[2])
	)

static func xyz2lab(c: Vector3) -> Vector3:
	var n = c / Vector3(95.047, 100, 108.883)
	var v = Vector3()

	v.x = pow(n.x, 1.0 / 3.0) if n.x > 0.008856 else (7.787 * n.x) + (16.0 / 116.0)
	v.y = pow(n.y, 1.0 / 3.0) if n.y > 0.008856 else (7.787 * n.y) + (16.0 / 116.0)
	v.z = pow(n.z, 1.0 / 3.0) if n.z > 0.008856 else (7.787 * n.z) + (16.0 / 116.0)

	return Vector3(
		(116.0 * v.y) - 16.0,
		500.0 * (v.x - v.y),
		200.0 * (v.y - v.z)
	)

static func rgb2lab(c: Vector3) -> Vector3:
	var lab = xyz2lab(rgb2xyz(c))
	return Vector3(
		lab.x / 100.0,
		0.5 + 0.5 * (lab.y / 127.0),
		0.5 + 0.5 * (lab.z / 127.0)
	)

static func lab2xyz(c: Vector3) -> Vector3:
	var fy = (c.x + 16.0) / 116.0
	var fx = c.y / 500.0 + fy
	var fz = fy - c.z / 200.0

	return Vector3(
		95.047 * (fx * fx * fx if fx > 0.206897 else (fx - 16.0 / 116.0) / 7.787),
		100.000 * (fy * fy * fy if fy > 0.206897 else (fy - 16.0 / 116.0) / 7.787),
		108.883 * (fz * fz * fz if fz > 0.206897 else (fz - 16.0 / 116.0) / 7.787)
	)

static func xyz2rgb(c: Vector3) -> Vector3:
	var mat = [
		Vector3(3.2406, -1.5372, -0.4986),
		Vector3(-0.9689, 1.8758, 0.0415),
		Vector3(0.0557, -0.2040, 1.0570)
	]

	var v = Vector3((c / 100.0).dot(mat[0]), (c / 100.0).dot(mat[1]), (c / 100.0).dot(mat[2]))
	var r = Vector3()

	r.x = (1.055 * pow(v[0], 1.0 / 2.4) - 0.055) if v[0] > 0.0031308 else 12.92 * v[0]
	r.y = (1.055 * pow(v[1], 1.0 / 2.4) - 0.055) if v[1] > 0.0031308 else 12.92 * v[1]
	r.z = (1.055 * pow(v[2], 1.0 / 2.4) - 0.055) if v[2] > 0.0031308 else 12.92 * v[2]

	return r

static func lab2rgb(c: Vector3) -> Vector3:
	return xyz2rgb(lab2xyz(Vector3(
		100.0 * c.x,
		2.0 * 127.0 * (c.y - 0.5),
		2.0 * 127.0 * (c.z - 0.5)
	)))
