Test task with next conditions:

Условная компьютерная игра.
Есть поселения, в которых есть ресурсы (железо, глина, зерно - не важно какие).
Прибегает армия пограбить данное поселение.
У армии есть грузоподъемность (не может миллион ресурсов унести).
Армия должна награбить ресурсов пропорционально.
Например, деревне ресусов [100, 300, 200]
грузоподъемность армии 120 - армия тогда унесет [20, 60, 40].
Задача - написать метод, который определяет сколько каких ресурсов унесет армия
На вход массив произвольной длины с текущими ресурсами в поселении и грузоподъемность армии.
На выходе массив той же длины с информацией, что украли.
Важно учитывать (в порядке понижения приоритетностфи):
1. Ресурсы могут исчисляться только целыми числами
2. Армия должна уйти максимально возможно загруженной
3. Пропорция ресурсов должна быть максимально точной.