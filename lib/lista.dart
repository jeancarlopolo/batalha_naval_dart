///Elemento de uma lista
class Node<T> {
  T item;
  Node<T>? next;
  Node(this.item, [this.next]);
}

///Lista ligada simples
class ListaLigada<E> {
  Node<E>? inicio;
  int? capacidade;

  ListaLigada([this.capacidade]);

  bool get isEmpty => inicio == null;

  bool get isFull => capacidade != null && capacidade! <= 0;

  int get length {
    int i = 0;
    Node<E>? aux = inicio;
    while (aux != null) {
      i++;
      aux = aux.next;
    }
    return i;
  }

  ///Adiciona um elemento no final da lista
  void insert(E item) {
    if (isFull) {
      throw Exception('Lista cheia');
    }
    if (isEmpty) {
      inicio = Node(item);
    } else {
      Node<E>? aux = inicio;
      while (aux!.next != null) {
        aux = aux.next;
      }
      aux.next = Node<E>(item);
    }
    capacidade = capacidade != null ? capacidade! - 1 : null;
  }

  ///Remove um elemento da lista
  void remove(E item) {
    if (isEmpty) {
      throw Exception('Lista vazia');
    }
    if (inicio!.item == item) {
      inicio = inicio!.next;
    } else {
      Node<E>? aux = inicio;
      while (aux!.next != null && aux.next!.item != item) {
        aux = aux.next;
      }
      if (aux.next == null) {
        throw Exception('Item não encontrado');
      }
      aux.next = aux.next!.next;
    }
    capacidade = capacidade != null ? capacidade! + 1 : null;
  }

  ///Remove o primeiro elemento da lista e o retorna
  E? pop() {
    if (isEmpty) {
      throw Exception('Lista vazia');
    }
    E? item = inicio!.item;
    inicio = inicio!.next;
    capacidade = capacidade != null ? capacidade! + 1 : null;
    return item;
  }

  ///Insere um elemento antes de outro
  void insertBefore(E item, E before) {
    if (isFull) {
      throw Exception('Lista cheia');
    }
    if (isEmpty) {
      throw Exception('Lista vazia');
    }
    if (inicio!.item == before) {
      inicio = Node(item, inicio);
    } else {
      Node<E>? aux = inicio;
      while (aux!.next != null && aux.next!.item != before) {
        aux = aux.next;
      }
      if (aux.next == null) {
        throw Exception('Item não encontrado');
      }
      aux.next = Node(item, aux.next);
    }
    capacidade = capacidade != null ? capacidade! - 1 : null;
  }

  ///Insere um elemento depois de outro
  void insertAfter(E item, E after) {
    if (isFull) {
      throw Exception('Lista cheia');
    }
    if (isEmpty) {
      throw Exception('Lista vazia');
    }
    Node<E>? aux = inicio;
    while (aux != null && aux.item != after) {
      aux = aux.next;
    }
    if (aux == null) {
      throw Exception('Item não encontrado');
    }
    aux.next = Node(item, aux.next);
    capacidade = capacidade != null ? capacidade! - 1 : null;
  }
}

