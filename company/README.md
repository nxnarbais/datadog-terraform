# Usage Examples

Here is an example of structure where the each environment and team can have a different folder to manage their Datadog assets.

## prod > team_d

- Utilization of system modules

## prod > team_a

- Utilization of the system module (which himself uses other more detailed system modules)
- Additional monitor manually created

## prod > team_b

- Utilization of multiple modules for system, service and backup

## prod > team_c

- Utilization of a templated service dashboard (timeboard).

## dev > team_a

- Utilization of a service module