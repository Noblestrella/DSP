import cv2

# =====================================================
# CONEXIÓN CON LA ESP32-CAM
# =====================================================

url = "http://192.168.100.170:81/stream"

cap = cv2.VideoCapture(url)


while True:

    # =================================================
    # RECEPCIÓN DE LA IMAGEN
    # =================================================

    ret, frame = cap.read()

    if not ret:
        print("Error recibiendo imagen")
        break


    # =================================================
    # CORREGIR ORIENTACIÓN
    # =================================================

    frame = cv2.flip(frame, -1)


    # =================================================
    # 1. ESCALA DE GRISES
    # =================================================

    gray = cv2.cvtColor(
        frame,
        cv2.COLOR_BGR2GRAY
    )


    # =================================================
    # 2. FILTRO GAUSSIANO
    # =================================================

    blur = cv2.GaussianBlur(
        gray,
        (5, 5),
        0
    )


    # =================================================
    # 3. UMBRALIZACIÓN ADAPTATIVA
    # =================================================

    binary = cv2.adaptiveThreshold(
        blur,
        255,
        cv2.ADAPTIVE_THRESH_GAUSSIAN_C,
        cv2.THRESH_BINARY,
        11,
        2
    )


    # =================================================
    # 4. LIMPIEZA MORFOLÓGICA
    # =================================================

    kernel = cv2.getStructuringElement(
        cv2.MORPH_ELLIPSE,
        (5, 5)
    )

    clean = cv2.morphologyEx(
        binary,
        cv2.MORPH_OPEN,
        kernel
    )

    clean = cv2.morphologyEx(
        clean,
        cv2.MORPH_CLOSE,
        kernel
    )


    # =================================================
    # 5. BUSCAR CONTORNOS EN LA IMAGEN LIMPIA
    # =================================================

    contours, hierarchy = cv2.findContours(
        clean,
        cv2.RETR_EXTERNAL,
        cv2.CHAIN_APPROX_SIMPLE
    )


    # =================================================
    # 6. FILTRAR CONTORNOS PEQUEÑOS
    # =================================================

    valid_contours = []

    for contour in contours:

        area = cv2.contourArea(contour)

        if area > 1000:
            valid_contours.append(contour)


    # =================================================
    # 7. ORDENAR CONTORNOS POR ÁREA
    # =================================================

    valid_contours = sorted(
        valid_contours,
        key=cv2.contourArea,
        reverse=True
    )


    # =================================================
    # 8. CREAR IMAGEN DE RESULTADO
    # =================================================

    detected_image = frame.copy()


    # =================================================
    # 9. SELECCIONAR EL OBJETO PRINCIPAL
    # =================================================

    if len(valid_contours) > 0:

        largest_contour = valid_contours[0]

        area = cv2.contourArea(
            largest_contour
        )


        # ---------------------------------------------
        # DIBUJAR CONTORNO VERDE
        # ---------------------------------------------

        cv2.drawContours(
            detected_image,
            [largest_contour],
            -1,
            (0, 255, 0),
            3
        )


        # ---------------------------------------------
        # CALCULAR RECTÁNGULO
        # ---------------------------------------------

        x, y, w, h = cv2.boundingRect(
            largest_contour
        )


        # ---------------------------------------------
        # DIBUJAR RECTÁNGULO AZUL
        # ---------------------------------------------

        cv2.rectangle(
            detected_image,
            (x, y),
            (x + w, y + h),
            (255, 0, 0),
            2
        )


        # ---------------------------------------------
        # MOSTRAR INFORMACIÓN
        # ---------------------------------------------

        cv2.putText(
            detected_image,
            f"Area: {int(area)} px",
            (x, y - 10),
            cv2.FONT_HERSHEY_SIMPLEX,
            0.7,
            (0, 255, 0),
            2
        )


    # =================================================
    # 10. DETECCIÓN DE BORDES
    # =================================================

    edges = cv2.Canny(
        blur,
        50,
        150
    )


    # =================================================
    # MOSTRAR RESULTADOS
    # =================================================

    cv2.imshow(
        "1 - Imagen Original",
        frame
    )

    cv2.imshow(
        "2 - Escala de Grises",
        gray
    )

    cv2.imshow(
        "3 - Filtro Gaussiano",
        blur
    )

    cv2.imshow(
        "4 - Bordes",
        edges
    )

    cv2.imshow(
        "6 - Imagen Binaria",
        binary
    )

    cv2.imshow(
        "7 - Imagen Limpia",
        clean
    )

    cv2.imshow(
        "8 - Objeto Detectado",
        detected_image
    )


    # =================================================
    # SALIR CON Q
    # =================================================

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break


# =====================================================
# CERRAR
# =====================================================

cap.release()

cv2.destroyAllWindows()