classdef ArmScara
    properties
        a, alpha, d, theta
        type, base, n
        x, T, end_effector, J
        fig, quiver_x, quiver_y, quiver_z
    end
    methods
        function obj = ArmScara(a, alpha, d, theta, type, base)
            obj.a = a;
            obj.alpha = deg2rad(alpha);
            obj.d = d;
            obj.theta = deg2rad(theta);
            obj.type = type;
            obj.base = base;
            obj.n = length(d); 
        end
        
        function obj = set_joint_variable(obj, index, q)
            if obj.type(index) == 'r'
                obj.theta(index) = q;
            elseif obj.type(index) == 'p'
                obj.d(index) = q;
            end
        end
        
        function obj = update(obj)
            obj.T = forward_kinematics(obj.n, obj.a, obj.alpha, obj.d, obj.theta);
      % tính vị trí góc tọa độ của hệ trục tọa độ i trong hệ tọa độ gốc
            for i = 1:obj.n+1
                obj.x(:,i) = (obj.T(1:3,4,i)) + obj.base;
                % :,i là tất cả các hàng của cột y trong mảng 2D x
                %1:3,4,i : từ hàng 1 đến hàng 3 của cột thứ 4 của mảng thứ
                %i, mảng 3D
           end
            obj.end_effector = [obj.x(:,obj.n+1); tform2eul(obj.T(:,:,obj.n+1))'];
            obj.J = jacobian1(obj.n, obj.a, obj.alpha, obj.d, obj.theta, obj.type);
        end
        
        function plot_frame(obj, axes)
            plot3(axes, obj.x(1,:), obj.x(2,:), obj.x(3,:), '-o', 'LineWidth', 5);
        end
        %obj.x(1,:) là tập hợp các tọa độ x của các gốc tọa độ của các hệ
        %tọa độ của các khớp, y và z tương tự
        function plot_coords(obj, axes)
            %khởi tạo các ma trận 3 hàng n+1 cột với tất cả giá trị là 0
            vx = zeros(3, obj.n+1);
            vy = zeros(3, obj.n+1);
            vz = zeros(3, obj.n+1);
 %lấy i1 theo i0, j0,k0, j1, z1 tương tự
 %vx (:,i) biểu diễn hướng của trục x của hệ trục tọa độ i so với hệ
 %trục tọa độ 0, vy vz tương tự
            for i = 1:obj.n+1
                vx(:,i) = obj.T(1:3,1:3,i)*[1; 0; 0];
                vy(:,i) = obj.T(1:3,1:3,i)*[0; 1; 0];
                vz(:,i) = obj.T(1:3,1:3,i)*[0; 0; 1];
            end
            % Plot ref frame of each joint
            %quiver3 là hàm vẽ hệ vector 3D
            axis_scale = 1/3;
            quiver3(axes, obj.x(1,:), obj.x(2,:), obj.x(3,:), vx(1,:), vx(2,:), vx(3,:), axis_scale, 'b', 'LineWidth', 2);
            quiver3(axes, obj.x(1,:), obj.x(2,:), obj.x(3,:), vy(1,:), vy(2,:), vy(3,:), axis_scale, 'g', 'LineWidth', 2);
            quiver3(axes, obj.x(1,:), obj.x(2,:), obj.x(3,:), vz(1,:), vz(2,:), vz(3,:), axis_scale, 'r', 'LineWidth', 2);
    end 
   
       function plot_arm(obj, axes)
            % Parameters
             COLOR_RED = [0.7, 0.3, 0.3];
             COLOR_GREEN = [0.3, 0.7, 0.3];
             COLOR_BLUE = [0.3, 0.7, 0.7];
             opacity = 0.7;
            
           W2 = 2;
           R1 = 1.5;
           R2 = W2/2;
           H2 = 1.01;
           H1 = 1.5;
           L2 = obj.a(2);
           H3 = 2.215;
           L3 = obj.a(3);
            
            % Link 1
            th = linspace(-pi, pi, 100);
            X = R1*cos(th) + obj.x(1,1);
            Y = R1*sin(th) + obj.x(2,1);
            Z1 = ones(1, size(th, 2))*obj.x(3,1);
            Z2 = ones(1, size(th, 2))*H1;
            
           surf(axes, [X;X], [Y;Y], [Z1;Z2], 'FaceColor', COLOR_RED, 'EdgeColor', 'none', 'FaceAlpha', opacity)
           fill3(axes, X, Y, Z1, COLOR_RED, 'FaceAlpha', opacity);
           fill3(axes, X, Y, Z2, COLOR_RED, 'FaceAlpha', opacity);
            
            % Link 2
            X = obj.x(1,2);
            Y = obj.x(2,2);
            Z1 = obj.d(1)- H2;
            Z2 = H1 + H2;
            yaw = (obj.theta(1)+obj.theta(2));
            
            fill3(axes, [X-W2/2*sin(yaw), X+W2/2*sin(yaw), X+L2*cos(yaw)+W2/2*sin(yaw), X+L2*cos(yaw)-W2/2*sin(yaw)], [Y+W2/2*cos(yaw), Y-W2/2*cos(yaw), Y+L2*sin(yaw)-W2/2*cos(yaw), Y+L2*sin(yaw)+W2/2*cos(yaw)], [Z1, Z1, Z1, Z1], COLOR_GREEN, 'FaceAlpha', opacity)
            fill3(axes, [X-W2/2*sin(yaw), X+W2/2*sin(yaw), X+L2*cos(yaw)+W2/2*sin(yaw), X+L2*cos(yaw)-W2/2*sin(yaw)], [Y+W2/2*cos(yaw), Y-W2/2*cos(yaw), Y+L2*sin(yaw)-W2/2*cos(yaw), Y+L2*sin(yaw)+W2/2*cos(yaw)], [Z2, Z2, Z2, Z2], COLOR_GREEN, 'FaceAlpha', opacity)
            fill3(axes, [X+W2/2*sin(yaw), X+W2/2*sin(yaw)+L2*cos(yaw), X+W2/2*sin(yaw)+L2*cos(yaw), X+W2/2*sin(yaw)], [Y-W2/2*cos(yaw), Y+L2*sin(yaw)-W2/2*cos(yaw), Y+L2*sin(yaw)-W2/2*cos(yaw), Y-W2/2*cos(yaw)], [Z1, Z1, Z2, Z2], COLOR_GREEN, 'FaceAlpha', opacity)
            fill3(axes, [X-W2/2*sin(yaw), X-W2/2*sin(yaw)+L2*cos(yaw), X-W2/2*sin(yaw)+L2*cos(yaw), X-W2/2*sin(yaw)], [Y+W2/2*cos(yaw), Y+L2*sin(yaw)+W2/2*cos(yaw), Y+L2*sin(yaw)+W2/2*cos(yaw), Y+W2/2*cos(yaw)], [Z1, Z1, Z2, Z2], COLOR_GREEN, 'FaceAlpha', opacity)
            
            th = linspace(pi+yaw-pi/2, 2*pi+yaw-pi/2, 100);
            X = R2*cos(th) + obj.x(1,2);
            Y = R2*sin(th) + obj.x(2,2);
            Z1 = ones(1,size(th,2))*(obj.x(3,2) - H2);
           Z2 = ones(1,size(th,2))*obj.x(3,2);
            
            surf(axes, [X;X], [Y;Y], [Z1;Z2], 'FaceColor', COLOR_GREEN, 'EdgeColor', 'none', 'FaceAlpha', opacity)
            fill3(axes, X, Y, Z1, COLOR_GREEN, 'FaceAlpha', opacity);
            fill3(axes, X, Y, Z2, COLOR_GREEN, 'FaceAlpha', opacity);
            
            th = linspace(0+yaw-pi/2, pi+yaw-pi/2, 100);
            X = R2*cos(th) + obj.x(1,3);
            Y = R2*sin(th) + obj.x(2,3);
            
            surf(axes, [X;X], [Y;Y], [Z1;Z2], 'FaceColor', COLOR_GREEN, 'EdgeColor', 'none', 'FaceAlpha', opacity)
            fill3(axes, X, Y, Z1, COLOR_GREEN, 'FaceAlpha', opacity);
            fill3(axes, X, Y, Z2, COLOR_GREEN, 'FaceAlpha', opacity);
            
            % Link 3
            X = obj.x(1,3);
            Y = obj.x(2,3);
            Z1 = obj.x(3,3);
            Z2 = obj.x(3,3) + H3;
            yaw = (obj.theta(1)+obj.theta(2)+obj.theta(3));
            
         fill3(axes, [X-W2/2*sin(yaw), X+W2/2*sin(yaw), X+L3*cos(yaw)+W2/2*sin(yaw), X+L3*cos(yaw)-W2/2*sin(yaw)], [Y+W2/2*cos(yaw), Y-W2/2*cos(yaw), Y+L3*sin(yaw)-W2/2*cos(yaw), Y+L3*sin(yaw)+W2/2*cos(yaw)], [Z1, Z1, Z1, Z1], COLOR_BLUE, 'FaceAlpha', opacity)
         fill3(axes, [X-W2/2*sin(yaw), X+W2/2*sin(yaw), X+L3*cos(yaw)+W2/2*sin(yaw), X+L3*cos(yaw)-W2/2*sin(yaw)], [Y+W2/2*cos(yaw), Y-W2/2*cos(yaw), Y+L3*sin(yaw)-W2/2*cos(yaw), Y+L3*sin(yaw)+W2/2*cos(yaw)], [Z2, Z2, Z2, Z2], COLOR_BLUE, 'FaceAlpha', opacity)
         fill3(axes, [X+W2/2*sin(yaw), X+W2/2*sin(yaw)+L3*cos(yaw), X+W2/2*sin(yaw)+L3*cos(yaw), X+W2/2*sin(yaw)], [Y-W2/2*cos(yaw), Y+L3*sin(yaw)-W2/2*cos(yaw), Y+L3*sin(yaw)-W2/2*cos(yaw), Y-W2/2*cos(yaw)], [Z1, Z1, Z2, Z2], COLOR_BLUE, 'FaceAlpha', opacity)
         fill3(axes, [X-W2/2*sin(yaw), X-W2/2*sin(yaw)+L3*cos(yaw), X-W2/2*sin(yaw)+L3*cos(yaw), X-W2/2*sin(yaw)], [Y+W2/2*cos(yaw), Y+L3*sin(yaw)+W2/2*cos(yaw), Y+L3*sin(yaw)+W2/2*cos(yaw), Y+W2/2*cos(yaw)], [Z1, Z1, Z2, Z2], COLOR_BLUE, 'FaceAlpha', opacity)
            
           th = linspace(pi+yaw-pi/2, 2*pi+yaw-pi/2, 100);
           X = R2*cos(th) + obj.x(1,3);
           Y = R2*sin(th) + obj.x(2,3);
           Z1 = ones(1,size(th,2))*obj.x(3,3);
           Z2 = ones(1,size(th,2))*(obj.x(3,3) + H3);
           surf(axes, [X;X], [Y;Y], [Z1;Z2], 'FaceColor', COLOR_BLUE, 'EdgeColor', 'none', 'FaceAlpha', opacity);
           fill3(axes, X , Y , Z1, COLOR_BLUE, 'FaceAlpha', opacity);
           fill3(axes, X , Y , Z2, COLOR_BLUE, 'FaceAlpha', opacity);
            
            th = linspace(0+yaw-pi/2, pi+yaw-pi/2, 100);
            X = R2*cos(th) + obj.x(1,4);
            Y = R2*sin(th) + obj.x(2,4);
            surf(axes, [X;X], [Y;Y], [Z1;Z2], 'FaceColor', COLOR_BLUE, 'EdgeColor', 'none', 'FaceAlpha', opacity);
           fill3(axes, X , Y , Z1, COLOR_BLUE, 'FaceAlpha', opacity);
            fill3(axes, X , Y , Z2, COLOR_BLUE, 'FaceAlpha', opacity);
       end
        
        function plot_workspace(obj, axes)
            PURPLE_COLOR = [0.4940 0.1840 0.5560];
            
            th = deg2rad(linspace(-125, 125, 100));
            X = (obj.a(2) + obj.a(3))*cos(th);
            Y = (obj.a(2) + obj.a(3))*sin(th);
            Z1 = ones(1, size(th, 2))*(obj.d(1)-3.3);
            Z2 = ones(1, size(th, 2))*(obj.d(1)-1);
            surf(axes, [X;X], [Y;Y], [Z1;Z2], 'FaceColor', PURPLE_COLOR, 'EdgeColor', 'none', 'FaceAlpha', 0.3);
         %   R = sqrt(obj.a(2)^2 + obj.a(3)^2 - 2*obj.a(2)*obj.a(3)*cosd(180-125));
            R =1.7805
            phi = (125-72)*2;
            th = deg2rad(linspace(-phi-145, -125, 100));
            X = obj.a(2)*cos(-125*pi/180) + obj.a(3)*cos(th);
            Y = obj.a(2)*sin(-125*pi/180) + obj.a(3)*sin(th);
            surf(axes, [X;X], [Y;Y], [Z1;Z2], 'FaceColor', PURPLE_COLOR, 'EdgeColor', 'none', 'FaceAlpha', 0.3);
            
            th = deg2rad(linspace(125, phi+145, 100));
            X = obj.a(2)*cos(125*pi/180) + obj.a(3)*cos(th);
            Y = obj.a(2)*sin(125*pi/180) + obj.a(3)*sin(th);
            surf(axes, [X;X], [Y;Y], [Z1;Z2], 'FaceColor', PURPLE_COLOR, 'EdgeColor', 'none', 'FaceAlpha', 0.3);
            
            th = deg2rad(linspace(-180, 180, 100));
            X = R*cos(th);
            Y = R*sin(th);
            surf(axes, [X;X], [Y;Y], [Z1;Z2], 'FaceColor', PURPLE_COLOR, 'EdgeColor', 'none', 'FaceAlpha', 0.3);
        end
        
        function plot(obj, axes, coords, workspace)
            cla(axes)
            hold on;
            rotate3d(axes, 'on');
            xlabel(axes, 'x');
            ylabel(axes, 'y');
            zlabel(axes, 'z');
            xlim(axes, [obj.base(1)-8 obj.base(1)+8]);
            ylim(axes, [obj.base(2)-8 obj.base(2)+8]);
            zlim(axes, [obj.base(3)   obj.base(3)+8]);
            obj.plot_frame(axes);
            if coords
                obj.plot_coords(axes);
            end
            obj.plot_arm(axes);
            if workspace
                obj.plot_workspace(axes);
            end
            view(axes, 3);
            drawnow;
        end
    end
end