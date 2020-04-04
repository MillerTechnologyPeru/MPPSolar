/*
 *
 * C Header for MPP Solar
 *
 */

#include <stdint.h>
#include <stdbool.h>
#include <sys/types.h>
#include <sys/select.h>

/*
 Calculate CRC code for MPP Solar
 */
uint16_t mppsolar_crc(const uint8_t *bytes, uint8_t len);
